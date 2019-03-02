require 'rails_helper'

RSpec.describe Journey, type: :model do

  let(:journey) { build(:journey) }

  subject { journey }

  it { should be_valid }

  context 'search' do
    context 'published' do
      before do
        journey.title = 'Title'
        journey.description = "<p>Content</p>\n<strong>In html</strong>"
        journey.keywords = 'Keyword1 Keyword2'
        journey.published_status = 'PUBLISHED'
      end

      it 'creates Search with terms from title, content and keywords' do
        expect {
          journey.save!
        }.to change(PgSearch::Document, :count).by(1)
        expect(PgSearch::Document.first.searchable).to eq journey
        expect(PgSearch::Document.first.content).to eq 'title keyword1 keyword2 content in html'
      end

      context 'updating' do
        before do
          journey.save!
        end
        it 'updates terms and enabled status' do
          journey.update!(title: 'New title')
          expect(PgSearch::Document.first.content).to eq 'new title keyword1 keyword2 content in html'
        end
      end

      context 'setting as draft' do
        before do
          journey.save!
        end

        it 'deletes search' do
          expect{
            journey.update!(published_status: 'DRAFT')
          }.to change(PgSearch::Document, :count).by(-1)
        end
      end

      context 'has step' do
        let(:step) { create(:step, journey: journey, title: 'title', keywords: 'keywords', description: 'description') }
        it 'updates step after save' do
          journey.save!
          expect(PgSearch::Document.where(searchable: step).first.content).to eq 'title keywords description'
        end
      end
    end

    context 'draft' do
      before do
        journey.published_status = 'DRAFT'
      end
      it 'is disabled' do
        expect {
          journey.save!
        }.not_to change(PgSearch::Document, :count)
      end
    end

    describe 'search scope' do
      it 'matches relevant results based on occurrence' do
        journey.title = 'Batman Superman'
        journey.description = 'bla'
        journey.keywords = ''
        journey.save!
        journey2 = create(:journey, title: 'Batman Batman', description: 'bla', keywords: '')
        create(:journey, title: 'Superman', description: 'bla', keywords: '')

        expect(PgSearch.multisearch('Batman').map(&:searchable)).to eq [journey2, journey]
      end
    end
  end

end
