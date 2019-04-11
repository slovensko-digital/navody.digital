require 'rails_helper'

RSpec.feature 'Search', type: :feature do
  background do
    @matching = 'Batman'
    unmatching = 'Superman'
    @matching_journey = create(:journey, title: "#{@matching} journey")
    @matching_step = create(:step, title: "#{@matching} step", journey: @matching_journey)
    @unmatching_step = create(:step, title: "#{unmatching} step", journey: @matching_journey)
    @unmatching_journey = create(:journey, title: "#{unmatching} journey")
    @unmatching_journey_matching_step = create(:journey, title: "#{unmatching} 2nd journey")
    @matching_step2 = create(:step, title: "#{@matching} step2", journey: @unmatching_journey_matching_step)
    @matching_faq = create(:page, title: "#{@matching} faq", is_faq: true)
    @unmatching_faq = create(:page, title: "#{unmatching} faq", is_faq: true)
  end

  scenario 'Visitor searches for topic of interest' do
    visit root_path
    fill_in 'q', with: @matching
    click_button 'Hľadať'
    expect(page).to have_text('Výsledky vyhľadávania')
    expect(page).to have_text(@matching_journey.title)
    expect(page).to have_text(@matching_step.title)
    expect(page).to have_text(@matching_faq.title)
    expect(page).to have_text(@unmatching_journey_matching_step.title)
    expect(page).to have_text(@matching_step2.title)
    expect(page).not_to have_text(@unmatching_journey.title)
    expect(page).not_to have_text(@unmatching_step.title)
    expect(page).not_to have_text(@unmatching_faq.title)
  end

  scenario 'Not found results' do
    visit root_path
    fill_in 'q', with: 'Neexistujuci vyraz'
    click_button 'Hľadať'
    expect(page).to have_text('Pre tento výraz sme nenašli žiadne výsledky.')
  end
end
