require 'rails_helper'

RSpec.feature 'Categories', type: :feature do
  scenario 'Visitor see category detail' do
    published_journey = create(:journey, title: "published journey", published_status: 'PUBLISHED')

    categorization = create(:categorization, categorizable: published_journey)

    category = create(:category, name: "byvanie", categorizations: [categorization])

    published_journey.search_documents.update_all(featured: true)

    visit category_path(category)

    expect(page).to have_text(category.name)
    expect(page).to have_text(published_journey.title)
  end
end
