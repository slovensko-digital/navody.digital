require 'rails_helper'

RSpec.describe Page, type: :model do

  let(:page) { build(:page) }

  subject { page }

  it { should be_valid }

  context 'search' do
    context 'is faq' do
      before do
        page.title = 'Title'
        page.content = 'Content'
        page.keywords = 'Keyword1 Keyword2'
        page.is_faq = true
      end
      it 'creates Search with terms from title, content and keywords' do
        expect {
          page.save!
        }.to change(PgSearch::Document, :count).by(1)
        expect(PgSearch::Document.first.searchable).to eq page
        expect(PgSearch::Document.first.content).to eq 'title keyword1 keyword2 content'
      end

      context 'updating' do
        before do
          page.save!
        end
        it 'updates terms' do
          page.update!(title: 'New title')
          expect(PgSearch::Document.first.content).to eq 'new title keyword1 keyword2 content'
        end
      end
    end

    context 'no faq' do
      it 'is not stored' do
        expect {
          page.save!
        }.not_to change(PgSearch::Document, :count)
      end
    end

    describe 'search scope' do
      it 'matches relevant results based on occurrence' do
        page.title = 'Batman Superman'
        page.content = 'bla'
        page.keywords = ''
        page.is_faq = true
        page.save!
        page2 = create(:page, title: 'Batman Batman', content: 'bla', keywords: '', is_faq: true)
        create(:page, title: 'Superman', content: 'bla', keywords: '')

        expect(PgSearch.multisearch('Batman').map(&:searchable)).to eq [page2, page]
      end
    end
  end

end
