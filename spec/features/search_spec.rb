require 'rails_helper'

RSpec.feature 'Search', type: :feature do
  scenario 'Visitor searches for topic of interest' do
    matching = 'Batman'
    unmatching = 'Superman'
    
    matching_journey = create(:journey, title: "#{matching} journey")
    matching_step = create(:step, title: "#{matching} step", journey: matching_journey)
    unmatching_step = create(:step, title: "#{unmatching} step", journey: matching_journey)
    unmatching_journey = create(:journey, title: "#{unmatching} journey")
    unmatching_journey_matching_step = create(:journey, title: "#{unmatching} 2nd journey")
    matching_step2 = create(:step, title: "#{matching} step2", journey: unmatching_journey_matching_step)
    matching_faq = create(:page, title: "#{matching} faq", is_faq: true)
    unmatching_faq = create(:page, title: "#{unmatching} faq", is_faq: true)

    visit root_path
    fill_in 'q', with: matching
    click_button 'Hľadať'

    expect(page).to have_text('Výsledky vyhľadávania')
    expect(page).to have_text(matching_journey.title)
    expect(page).to have_text(matching_step.title)
    expect(page).to have_text(matching_faq.title)
    expect(page).to have_text(unmatching_journey_matching_step.title)
    expect(page).to have_text(matching_step2.title)
    expect(page).not_to have_text(unmatching_journey.title)
    expect(page).not_to have_text(unmatching_step.title)
    expect(page).not_to have_text(unmatching_faq.title)
  end

  scenario 'Not found results' do
    visit root_path
    fill_in 'q', with: 'Neexistujuci vyraz'
    click_button 'Hľadať'
    expect(page).to have_text('Pre tento výraz sme nenašli žiadne výsledky.')
  end

  scenario 'Visitor is able to see only searchable pages' do
    matching = "batman"

    faq_page = create(:page, title: "#{matching} faq is visible", is_faq: true, is_searchable: false)
    searchable_page = create(:page, title: "#{matching} searchable", is_faq: false, is_searchable: true)
    non_searchable_page =create(:page, title: "#{matching} non faq and not searchable", is_faq: false, is_searchable: false)

    visit root_path
    fill_in 'q', with: matching
    click_button 'Hľadať'

    expect(page).to have_text('Výsledky vyhľadávania')
    expect(page).to have_text(faq_page.title)
    expect(page).to have_text(searchable_page.title)
    expect(page).not_to have_text(non_searchable_page.title)
  end

  scenario 'Visitor is able to see only searchable journeys and not see drafts or url only journeys' do
    matching = "batman"

    faq_journey = create(:journey, title: "#{matching} published", published_status: 'PUBLISHED')
    blank_journey = create(:journey, title: "#{matching} blank", published_status: 'BLANK')
    draft_journey = create(:journey, title: "#{matching} draft", published_status: 'DRAFT')
    url_only_journey = create(:journey, title: "#{matching} url only", published_status: 'URL_ONLY')

    visit root_path
    fill_in 'q', with: matching
    click_button 'Hľadať'

    expect(page).to have_text('Výsledky vyhľadávania')
    expect(page).to have_text(faq_journey.title)
    expect(page).to have_text(blank_journey.title)
    expect(page).not_to have_text(draft_journey.title)
    expect(page).not_to have_text(url_only_journey.title)
  end

  scenario 'Visitor is able to see only searchable apps and not see drafts apps' do
    matching = "batman"

    faq_app = create(:app, title: "#{matching} published", published_status: 'PUBLISHED')
    draft_app = create(:journey, title: "#{matching} draft", published_status: 'DRAFT')

    visit root_path
    fill_in 'q', with: matching
    click_button 'Hľadať'

    expect(page).to have_text('Výsledky vyhľadávania')
    expect(page).to have_text(faq_app.title)
    expect(page).not_to have_text(draft_app.title)
  end
end
