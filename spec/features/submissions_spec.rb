require 'rails_helper'

RSpec.feature "Submissions feature", type: :feature do
  let(:user) { create(:user, email: 'someone@example.com') }

  def submit_tax_submission(email: nil)
    visit test_submissions_path
    fill_in 'callback_url', with: root_path
    fill_in 'email', with: email if email
    click_button 'Podať'
  end

  scenario 'As an anonymous user I can send submission instructions to my email and continue' do
    submit_tax_submission

    expect(page).to have_content('Podanie, ktoré ste pripravili je potrebné ešte odoslať.')

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'
    check 'Chcem dostávať novinky pre samostatne zárobkovo činné osoby'

    expect(EmailService).to receive(:send_email)

    click_button 'Chcem takéto emaily a ísť ďalej'

    expect(page).to have_content('Na Váš email sme Vám zaslali všetky potrebné inštrukcie')

    click_on 'Pokračovať na ďalšie inštrukcie'

    expect(page).to have_current_path(root_path)
  end

  scenario 'As an anonymous user I can send submission instructions to my email and download a file' do
    submit_tax_submission

    expect(EmailService).to receive(:send_email)

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'
    click_button 'Chcem takéto emaily a ísť ďalej'

    expect(page).to have_content('odklad-danoveho-priznania.xml')

    click_link 'Stiahnuť súbor'

    expect(page.body).to include('<?xml')
  end

  scenario 'As a signed in user I can send submission instructions to my email and continue' do
    sign_in(user)

    submit_tax_submission(email: user.email)

    expect(page).to have_content('Podanie, ktoré ste pripravili je potrebné ešte odoslať.')

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'
    check 'Chcem dostávať novinky pre samostatne zárobkovo činné osoby'

    expect(EmailService).to receive(:send_email).once
    expect(EmailService).to receive(:subscribe_to_newsletter).once

    click_button 'Chcem takéto emaily a ísť ďalej'

    expect(page).to have_content('Na Váš email sme Vám zaslali všetky potrebné inštrukcie')

    click_on 'Pokračovať na ďalšie inštrukcie'

    expect(page).to have_current_path(root_path)
  end

  scenario 'As signed in user I can send submission instructions to my email and download a file' do
    sign_in(user)

    submit_tax_submission(email: user.email)

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'

    expect(EmailService).to receive(:send_email)
    click_button 'Chcem takéto emaily a ísť ďalej'

    expect(page).to have_content('odklad-danoveho-priznania.xml')

    click_link 'Stiahnuť súbor'

    expect(page.body).to include('<?xml')
  end
end
