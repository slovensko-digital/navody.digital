require 'rails_helper'

RSpec.describe Step, type: :model do

  let(:journey) { create(:journey, title: 'journey', description: 'journey', keywords: 'journey') }
  let(:step) { build(:step, journey: journey) }

  subject { step }

  it { should be_valid }

  context 'search' do
    context 'published journey' do
      before do
        step.title = 'Title'
        step.description = "<p>Content</p>\n<strong>In html</strong>"
        step.keywords = 'Keyword1 Keyword2'
        step.journey.published_status = 'PUBLISHED'
      end

      it 'creates Search with terms from title, content and keywords, stores for journey' do
        expect {
          step.save!
        }.to change(Document, :count).by(1)
        search = Document.where(searchable: step).first
        expect(search.content).to eq 'content in html'
        expect(search.keywords).to eq 'keyword1 keyword2'
        expect(search.title).to eq 'title'
        search = Document.where(searchable: journey).first
        expect(search.content).to eq 'journey content in html'
        expect(search.keywords).to eq 'journey keyword1 keyword2'
        expect(search.title).to eq 'journey title'
      end

      context 'updating' do
        before do
          step.save!
        end
        it 'updates terms' do
          step.update!(title: 'New title')
          search = Document.where(searchable: step).first
          expect(search.title).to eq 'new title'
          search = Document.where(searchable: journey).first
          expect(search.title).to eq 'journey new title'
        end
      end
    end

    context 'draft journey' do
      before do
        step.journey.update!(published_status: 'DRAFT')
      end

      it 'is disabled' do
        expect {
          step.save!
        }.not_to change(Document, :count)
      end
    end

    describe 'search scope' do
      it 'matches relevant results based on occurrence' do
        step.title = 'Batman Superman'
        step.description = 'bla'
        step.keywords = ''
        step.save!
        step2 = create(:step, title: 'Batman Batman', description: 'bla', keywords: '', journey: journey)
        create(:step, title: 'Superman', description: 'bla', keywords: '', journey: journey)

        expect(Document.search('Batman').where(searchable_type: 'Step').map(&:searchable)).to eq [step2, step]
      end
    end
  end
end
