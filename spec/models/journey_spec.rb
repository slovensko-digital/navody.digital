require 'rails_helper'

RSpec.describe Journey, type: :model do

  let(:journey) { build(:journey) }

  subject { journey }

  it { should be_valid }

  context 'search' do
    before do
      journey.title = 'Title'
      journey.description = "<p>Content</p>\n<strong>In html</strong>"
      journey.keywords = 'Keyword1 Keyword2'
      journey.published_status = 'DRAFT'
    end

    context 'published' do
      before do
        journey.published_status = 'PUBLISHED'
      end

      it 'creates Search with terms from title, content and keywords' do
        expect {
          journey.save!
        }.to change(PgSearch::Document, :count).by(1)
        search = PgSearch::Document.first
        expect(search.searchable).to eq journey
        expect(search.content).to eq 'content in html'
        expect(search.keywords).to eq 'keyword1 keyword2'
        expect(search.title).to eq 'title'
      end

      context 'updating' do
        before do
          journey.save!
        end
        it 'updates terms and enabled status' do
          journey.update!(title: 'New title')
          search = PgSearch::Document.first
          expect(search.title).to eq 'new title'
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
    end

    context 'draft' do
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
        journey.published_status = 'PUBLISHED'
        journey.save!
        journey2 = create(:journey, title: 'Batman Batman', description: 'bla', keywords: '')
        _unmatched = create(:journey, title: 'Superman', description: 'bla', keywords: '')

        expect(PgSearch::Document.search('Batman').map(&:searchable)).to eq [journey2, journey]
      end
    end

    context 'has step' do
      let!(:step) { create(:step, journey: journey, title: 'step-title', keywords: 'step-keywords', description: 'step-description') }

      context 'published' do
        before do
          journey.published_status = 'PUBLISHED'
        end

        it 'stores step for journey' do
          expect{
            journey.save!
          }.to change(PgSearch::Document, :count).by(2)
          search = PgSearch::Document.where(searchable: step).first
          expect(search.content).to eq 'step-description'
          expect(search.keywords).to eq 'step-keywords'
          expect(search.title).to eq 'step-title'
          search = PgSearch::Document.where(searchable: journey).first
          expect(search.content).to eq 'content in html step-description'
          expect(search.keywords).to eq 'keyword1 keyword2 step-keywords'
          expect(search.title).to eq 'title step-title'
          journey.reload.update!(title: 'new title')
        end

        context 'updating to draft' do
          it 'removes step and journey from index' do
            journey.save!
            expect{
              journey.update!(published_status: 'DRAFT')
            }.to change(PgSearch::Document, :count).by(-2)
          end
        end

      end

      context 'draft' do
        it 'does not store to index' do
          expect{
            journey.save!
          }.not_to change(PgSearch::Document, :count)
        end

        context 'updating to published' do
          it 'creates index for journey and step' do
            journey.published_status = 'PUBLISHED'
            expect{
              journey.save!
            }.to change(PgSearch::Document, :count).by(2)
          end
        end
      end
    end
  end

  it 'creates new step with filled position' do
    journey.save
    create(:step, journey_id: journey.id, position: 1)
    step = journey.new_step
    expect(step.position).to eq 2
  end

  it 'creates new step with filled position when empty' do
    journey.save
    step = journey.new_step
    expect(step.position).to eq 1
  end
end
