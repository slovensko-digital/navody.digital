require 'rails_helper'

RSpec.feature "FAQ", type: :feature do
  background do
    @faq = create(:page, :faq)
  end

  scenario 'As a visitor I want to see FAQs on homepage' do
    visit root_path

    expect(page).to have_text('Často kladené otázky')
    expect(page).to have_text(@faq.title)
  end

  scenario 'As a visitor I want to see all FAQs' do
    visit root_path
    click_link 'Často kladené otázky'

    expect(page).to have_title('Často kladené otázky')
    expect(page).to have_text(@faq.title)
  end

  scenario 'As a visitor I want to see FAQ answered' do
    visit root_path

    click_link @faq.title

    expect(page).to have_text(@faq.content)
  end
end
