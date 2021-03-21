require 'rails_helper'

RSpec.feature "Submissions feature", type: :feature do
  let(:user) { create(:user, email: 'someone@example.com') }

  def submit_tax_submission(email: nil, callback_url: root_path)
    visit test_submissions_path
    fill_in 'callback_url', with: callback_url
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
    perform_enqueued_jobs

    expect(page).to have_content('Na Váš email sme Vám zaslali všetky potrebné inštrukcie')

    click_on 'Pokračovať na ďalšie inštrukcie'

    expect(page).to have_current_path(root_path)
  end

  scenario 'As an anonymous user I can send submission instructions to my email and download a file' do
    submit_tax_submission

    expect(EmailService).to receive(:send_email)

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'
    click_button 'Chcem takéto emaily a ísť ďalej'
    perform_enqueued_jobs

    expect(page).to have_content('odklad-danoveho-priznania.xml')

    click_link 'Stiahnuť súbor'

    expect(page.body).to include('Testovací')
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
    perform_enqueued_jobs

    expect(page).to have_content('Na Váš email sme Vám zaslali všetky potrebné inštrukcie')

    click_on 'Pokračovať na ďalšie inštrukcie'

    expect(page).to have_current_path(root_path)
  end

  scenario 'As signed in user I can send submission instructions to my email and download a file' do
    sign_in(user)

    submit_tax_submission(email: user.email)

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'

    click_button 'Chcem takéto emaily a ísť ďalej'

    expect(EmailService).to receive(:send_email)
    perform_enqueued_jobs

    expect(page).to have_content('odklad-danoveho-priznania.xml')

    click_link 'Stiahnuť súbor'

    expect(page.body).to include('<?xml version="1.0"')
    expect(page.body).to include('Testovací') # check if utf-8 chars work
  end

  scenario 'As an anonymous user I want only to download files' do
    submit_tax_submission(email: user.email)

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'
    check 'Chcem dostávať novinky pre samostatne zárobkovo činné osoby'

    expect(EmailService).not_to receive(:send_email)

    click_button 'Súbory chcem len stiahnuť'

    expect(page).to have_content('Všetky tieto súbory si stiahnite na bezpečné miesto.')
    expect(page).to have_content('odklad-danoveho-priznania.xml')

    click_link 'Stiahnuť súbor'

    expect(page.body).to include('<?xml version="1.0"')
    expect(page.body).to include('Testovací') # check if utf-8 chars work
  end

  scenario 'As signed in user I want only to download files' do
    sign_in(user)

    submit_tax_submission(email: user.email)

    check 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie'
    check 'Chcem dostávať novinky pre samostatne zárobkovo činné osoby'

    expect(EmailService).not_to receive(:send_email)
    expect(EmailService).not_to receive(:subscribe_to_newsletter)

    click_button 'Súbory chcem len stiahnuť'

    expect(page).to have_content('Všetky tieto súbory si stiahnite na bezpečné miesto.')
    expect(page).to have_content('odklad-danoveho-priznania.xml')

    click_link 'Stiahnuť súbor'

    expect(page.body).to include('<?xml')
  end

  scenario 'As signed in user I want to finish submission and have a step marked as done' do
    journey = create(:journey, title: 'Odklad daňového priznania')
    create(:step, title: 'Pripraviť daňové priznanie', journey: journey)
    create(:step, title: 'Prihlásiť sa na finančnú správu', journey: journey)

    sign_in(user)
    submit_tax_submission(
      callback_url: '/zivotne-situacie/odklad-danoveho-priznania/krok/prihlasit-sa-na-financnu-spravu'
    )
    click_button 'Súbory chcem len stiahnuť'
    click_on 'Pokračovať na ďalšie inštrukcie'

    expect(current_path).to eq('/zivotne-situacie/odklad-danoveho-priznania/krok/prihlasit-sa-na-financnu-spravu')
    expect(page).to have_css('.sdn-timeline__bullet--done')
  end
end
