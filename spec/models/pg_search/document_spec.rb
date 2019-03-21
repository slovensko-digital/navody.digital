require 'rails_helper'

RSpec.describe PgSearch::Document, type: :model do

  subject { described_class.search(query) }

  let(:query) { 'Batman' }

  describe 'search' do
    context 'priority search' do
      it 'has bigger priority for title' do
        page2 = create(:page, is_faq: true, content: query)
        page1 = create(:page, is_faq: true, title: query)
        expect(subject.collect(&:searchable)).to eq [page1, page2]
      end

      it 'has bigger priority for keyword' do
        page2 = create(:page, is_faq: true, content: query)
        page1 = create(:page, is_faq: true, keywords: query)
        expect(subject.collect(&:searchable)).to eq [page1, page2]
      end
    end

    context 'any word' do
      let(:query) { 'Batman Superman' }
      it 'matches both query words' do
        page2 = create(:page, is_faq: true, title: 'Batman')
        page1 = create(:page, is_faq: true, title: 'Superman')
        expect(subject.collect(&:searchable)).to match_array [page1, page2]
      end
    end

    context 'prefix' do
        it 'does not match prefixed word' do
        create(:page, is_faq: true, title: 'Batmanized')
        expect(subject.collect(&:searchable)).to be_empty
      end
    end

    context 'doc length normalization' do
      it 'penalizes by document lengths' do
        page2 = create(:page, is_faq: true, title: (query+' ') * 20)
        page1 = create(:page, is_faq: true, title: (query+' ') * 5)
        expect(subject.collect(&:searchable)).to eq [page1, page2]
      end
    end
  end
end
