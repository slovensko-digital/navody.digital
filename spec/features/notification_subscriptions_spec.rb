require 'rails_helper'
require_relative '../../app/models/apps/ep_vote_app/application_form'

RSpec.feature "Notification subscriptions", type: :feature do
  let!(:user) {create(:user, email: 'someone@example.com')}
  let!(:blank_journey) {create(:journey, published_status: "BLANK", description: nil)}

  before do
    allow(Apps::EpVoteApp::ApplicationForm).to receive(:active?).and_return(true)
  end

  scenario 'As a visitor I want to subscribe to various notifications' do
    expect(SubscribeToNewsletterJob).to receive(:perform_later).with('johno@jsmf.net', 'VoteSubscription')

    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'V zahraničí'
    click_button 'Pokračovať'

    check 'Chcem dostávať upozornenia k voľbám'

    fill_in 'Emailová adresa', with: 'johno@jsmf.net'

    click_button 'Chcem dostávať tieto notifikácie'

    perform_enqueued_jobs

    visit link_in_last_email

    expect(page).to have_content('Aktivovali ste si užitočné notifikácie')
    expect(page).to have_content('Chcem dostávať upozornenia k voľbám')
  end

  scenario 'As a logged in user I want to subscribe to various notifications' do
    sign_in user
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'V zahraničí'
    click_button 'Pokračovať'

    check 'Chcem dostávať upozornenia k voľbám'

    clear_mail_deliveries

    expect(EmailService).to receive(:subscribe_to_newsletter)

    click_button 'Chcem dostávať tieto notifikácie'

    perform_enqueued_jobs

    expect(ActionMailer::Base.deliveries).to be_empty
  end

  scenario 'As an anonymous user I want to subscribe to blank journey notification' do
    visit journey_path(blank_journey)

    check 'Chcem odoberať informácie k tomuto návodu'

    fill_in 'Emailová adresa', with: 'example@email.com'

    click_button 'Chcem dostávať tieto notifikácie'
    perform_enqueued_jobs

    visit link_in_last_email

    expect(page).to have_content('Aktivovali ste si užitočné notifikácie')
  end

  scenario 'As a logged user I want to subscribe to blank journey notification' do
    sign_in(user)
    visit journey_path(blank_journey)

    check 'Chcem odoberať informácie k tomuto návodu'

    clear_mail_deliveries

    click_button 'Chcem dostávať tieto notifikácie'

    expect(ActionMailer::Base.deliveries).to be_empty
  end

  scenario 'I visit a page to see possible subscriptions' do
    visit notification_subscription_groups_path

    expect(page).to have_content('Aktivujte si užitočné notifikácie na email')
  end
end
