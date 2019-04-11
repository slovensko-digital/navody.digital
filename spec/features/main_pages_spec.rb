require 'rails_helper'

RSpec.feature 'Main pages', type: :feature do
  background do
    @page = create(:page)
  end

  scenario 'As a visitor I want to see a static page' do
    visit page_path(@page)

    expect(page).to have_text(@page.content)
  end
end
