require 'rails_helper'

RSpec.feature "FAQ", type: :feature do
  background do
    @faq = create(:page, :faq)
  end

  scenario 'As a visitor I want to see FAQs on homepage' do
    visit root_path

    expect(page).to have_text('Časté otázky')
    expect(page).to have_text(@faq.title)
    expect(page).to have_text(@faq.content)
  end

  scenario 'As a visitor I want to see all FAQs' do
    visit root_path
    click_link 'Časté otázky'

    expect(page).to have_title('Časté otázky')
    expect(page).to have_text(@faq.title)
    expect(page).to have_text(@faq.content)
  end
end
