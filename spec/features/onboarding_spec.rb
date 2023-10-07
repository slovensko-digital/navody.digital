require 'rails_helper'

RSpec.feature "Sessions" do
  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"
  end

  scenario 'As a visitor I want to see onboarding after first login (magic link path)' do
    OmniAuth.config.test_mode = false

    visit new_session_path

    within 'form#login-email' do
      fill_in :email, with: 'foo@bar.com'
    end

    clear_mail_deliveries

    click_on 'Prihlásiť sa e-mailom'
    perform_enqueued_jobs

    expect(ActionMailer::Base.deliveries.size).to eq 1

    visit link_in_last_email

    expect(page).to have_text('Vitajte na Návody.Digital')
  end

  scenario 'As a visitor I want to see onboarding after first login (google login path)' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google_oauth2',
      info: {
        email: 'foo@bar.com'
      }
    })

    visit root_path
    click_link 'Prihlásiť'
    click_on 'Prihlásiť sa cez Google'

    expect(page).to have_text('Vitajte na Návody.Digital')
  end

  scenario 'As a visitor I dont want to see onboarding after next login' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google_oauth2',
      info: {
        email: 'foo@bar.com'
      }
    })

    visit root_path
    click_link 'Prihlásiť'
    click_on 'Prihlásiť sa cez Google'

    click_on 'Odhlásiť'

    click_link 'Prihlásiť'
    click_on 'Prihlásiť sa cez Google'

    expect(page).not_to have_text('Vitajte na Návody.Digital')
  end
end
