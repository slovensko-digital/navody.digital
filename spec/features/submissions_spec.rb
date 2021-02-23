require 'rails_helper'
require 'httparty'

RSpec.feature "Notification subscriptions", type: :feature do
  let!(:user) { create(:user, email: 'someone@example.com') }

  let!(:submission_data) {
    {
      email: 'user_email@gmail.com',
      email_subject: 'Odklad daňového priznania',
      email_body: 'Žiadosť o odklad daňového priznania je pripravená. Stiahnite si súbor do počítača. Použijete ho neskôr na portáli Finančnej správy.',
      file_attachment: file_fixture('odklad-danoveho-priznania.xml').read,
      notification_subscriptions: ['TaxReturnSubscription'],
    }
  }

  def submit_tax_return
    path = "http://localhost:3000#{submission_path}"
    puts path
    HTTParty.post(path, { body: submission_data })
  end

  def sign_in(user)
    OmniAuth.config.test_mode = false
    visit new_session_path

    within 'form#login-email' do
      fill_in :email, with: user.email
    end

    click_on 'Prihlásiť sa e-mailom'

    visit link_in_last_email
  end

  scenario 'As a logged in user I got redirected back after finishing tax return app and want to subscribe to notifications and receive tax return submission result by email' do
    sign_in user

    submit_tax_return

    expect(page).to have_current_path(submission_path)
    expect(page).to have_content('k úspešnému vyplneniu')
    expect(page).to have_link('Stiahnuť XML súbor', href: download_submission_path)
    expect(page).to have_content('Aktivujte si aj upozornenia na email, aby ste na nič nezabudli.')
    expect(page).to have_content('Chcem odoberať pravidelné novinky Návody.Digital')
    expect(page).to have_content('Chcem, aby ste mi dali vedieť, keď bude dostupná aktuálna verzia aplikácie Priznanie.Digital')
    expect(page).to have_content('Chcem dostávať tieto notifikácie')


    expec

  end


  scenario 'As an anonymous user I got redirected after finishing tax return app and want to subscribe to notifications and receive tax return submission result by email' do
    submit_tax_return

    expect(page).to have_current_path(submission_path)
    expect(page).to have_content('k úspešnému vyplneniu')
    expect(page).to have_link('Stiahnuť XML súbor', href: download_submission_path)
    expect(page).to have_content('Aktivujte si aj upozornenia na email, aby ste na nič nezabudli.')
    expect(page).to have_content('Chcem odoberať pravidelné novinky Návody.Digital')
    expect(page).to have_content('Chcem, aby ste mi dali vedieť, keď bude dostupná aktuálna verzia aplikácie Priznanie.Digital')


  end

end
