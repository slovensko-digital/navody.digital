require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category) { build(:category) }

  context 'featured' do
    context 'creating featured category' do
      before do
        category.save!
      end

      it 'updates the count of featured categories' do
        expect(Category.featured.count).to eq 1
      end
    end

    context 'updating category to feature false' do
      before do
        category.featured = false
        category.save!
      end

      it 'nulls the count of feature categories' do
        expect(Category.featured.count).to eq 0
      end
    end
  end

  context 'documents in category' do
    before do
      category.save!
    end

    context 'empty category' do
      it 'has no documents' do
        expect(category.categorizations.count).to eq 0
      end
    end

    context 'adding journey, page and app to category' do
      let(:journey) { create(:journey) }
      let(:page) { create(:page) }
      let(:app) { create(:app) }

      before do
        journey.categorization = Categorization.new(categorizable: journey)
        journey.categorization.categories.append(category)
        page.categorization = Categorization.new(categorizable: page)
        page.categorization.categories.append(category)
        app.categorization = Categorization.new(categorizable: app)
        app.categorization.categories.append(category)
      end

      it 'makes the category have 3 documents' do
        expect(category.categorizations.count).to eq 3
      end
    end
  end
end
