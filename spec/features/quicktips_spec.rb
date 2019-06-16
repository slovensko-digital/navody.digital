require 'rails_helper'

RSpec.feature "Quick tips", type: :feature do
  background do
    @quick_tip = create(:quick_tip)
  end

  scenario 'As a visitor I want to find a quick tip' do
    visit quick_tip_path(@quick_tip)

    expect(page).to have_text('Časté otázky')
    expect(page).to have_title(@quick_tip.title)
  end
end
