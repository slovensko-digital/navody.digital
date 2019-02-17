require 'rails_helper'

RSpec.describe Page, type: :model do

  let(:page) { build(:page) }

  subject { page }

  it { should be_valid }

  context 'searchable' do
    it 'saves terms from title, content and keywords' do
      page.title = 'Title'
      page.content = 'Content'
      page.keywords = 'Keyword1 Keyword2'
      page.save!
      expect(page.search_terms).to eq 'title content keyword1 keyword2'
    end

    describe 'search scope' do
      it 'matches relevant results based on occurrence' do
        page.title = 'Batman Superman'
        page.content = 'bla'
        page.keywords = ''
        page.save!
        page2 = create(:page, title: 'Batman Batman', content: 'bla', keywords: '')
        create(:page, title: 'Superman', content: 'bla', keywords: '')

        expect(Page.search('Batman')).to eq [page2, page]
      end
    end
  end

end
