require 'rails_helper'

RSpec.feature 'Feedback Bar', type: :feature, js: true do

  scenario 'User opens feedback bar' do
    visit root_path
    find('#ga-feedback-bug-report').click

    expect(page.body).to have_text('Nahlásenie chyby')
  end

  scenario 'User submits feedback' do
    visit root_path
    find('#ga-feedback-bug-report').click
    fill_in 'bug_what_were_you_doing', with: 'Testing feedback bar'
    fill_in 'bug_what_went_wrong', with: 'Testing of feedback bar'
    expect_any_instance_of(Recaptcha::Adapters::ControllerMethods).to receive(:verify_recaptcha).and_return(true)
    within('#sdn-feedbackbar-form-foundbug') { click_button 'Odoslať' }

    expect(page).to have_text('Váš podnet bol odoslaný. Ďakujeme.')
  end

  scenario 'User submits feedback and Recaptcha is requested' do
    visit root_path
    find('#ga-feedback-bug-report').click
    fill_in 'bug_what_were_you_doing', with: 'Testing feedback bar'
    fill_in 'bug_what_went_wrong', with: 'Testing of feedback bar'
    expect_any_instance_of(Recaptcha::Adapters::ControllerMethods).to receive(:verify_recaptcha).and_return(false)
    within('#sdn-feedbackbar-form-foundbug') { click_button 'Odoslať' }

    expect(page).to have_text('Prosím, potvrďte, že nie ste robot.')
  end
end
