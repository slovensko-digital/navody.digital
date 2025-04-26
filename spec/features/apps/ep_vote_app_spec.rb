require 'rails_helper'
require_relative '../../../app/models/apps/ep_vote_app/application_form'

RSpec.feature "EP vote app", type: :feature do
  before do
    travel_to Date.new(2024, 5, 19)
  end

  scenario 'As a citizen I want to request voting permit via post' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Áno, mám trvalý pobyt v SR'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Ostáva už len 1 deň.')
    choose 'Nechám si ho poslať poštou'
    click_button 'Pokračovať'

    fill_in 'Meno, priezvisko, titul', with: 'Ferko Mrkva'
    fill_in 'Rodné číslo', with: '123'

    fill_in 'Ulica a číslo', with: 'Pupavova 31'
    fill_in 'PSČ', with: '456'
    fill_in 'Obec', with: 'Bratislava - Karlova ves'
    click_button 'Pokračovať'

    choose 'Na adresu trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Meno: Ferko Mrkva')
    expect(page).to have_content('Rodné číslo: 123')
    expect(page).to have_content('Trvalý pobyt: Pupavova 31, 456 Bratislava - Karlova ves')
    expect(page).to have_content('Štátna príslušnosť: slovenská')

    expect(page).to have_content 'Áno, túto vygenerovanú žiadosť som odoslal/a na úrad emailom a chcem pokračovať.'

    # TODO no way to check the checkbox
    # check 'Áno, túto vygenerovanú žiadosť som odoslal/a na úrad emailom a chcem pokračovať.'
    # click_button 'Dokončiť návod'
    # expect(page).to have_content('Počkajte na hlasovací preukaz')
  end

  scenario 'As a citizen I want to request voting permit via post to a different address' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Áno, mám trvalý pobyt v SR'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Ostáva už len 1 deň.')
    choose 'Nechám si ho poslať poštou'
    click_button 'Pokračovať'

    fill_in 'Meno, priezvisko, titul', with: 'Ferko Mrkva'
    fill_in 'Rodné číslo', with: '123'

    fill_in 'Ulica a číslo', with: 'Pupavova 31'
    fill_in 'PSČ', with: '456'
    fill_in 'Obec', with: 'Bratislava - Karlova ves'
    click_button 'Pokračovať'


    choose 'Na inú adresu'
    fill_in 'Ulica a číslo', with: 'Konvalinkova 3'
    fill_in 'PSČ', with: '456'
    fill_in 'Obec', with: 'Bratislava - Ruzinov'
    fill_in 'Štát', with: 'Slovensko'
    click_button 'Pokračovať'

    expect(page).to have_content('Meno: Ferko Mrkva')
    expect(page).to have_content('Rodné číslo: 123')
    expect(page).to have_content('Trvalý pobyt: Pupavova 31, 456 Bratislava - Karlova ves')
    expect(page).to have_content('Štátna príslušnosť: slovenská')

    expect(page).to have_content('Preukaz prosím zaslať na korešpondenčnú adresu:')
    expect(page).to have_content('Konvalinkova 3, 456 Bratislava - Ruzinov, Slovensko')

    # TODO no way to check the checkbox
    # check 'Áno, túto vygenerovanú žiadosť som odoslal/a na úrad emailom a chcem pokračovať.'
    # click_button 'Dokončiť návod'
    # expect(page).to have_content('Počkajte na hlasovací preukaz')
  end

  scenario 'As a citizen I want to request voting permit via authorized person' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Áno, mám trvalý pobyt v SR'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Ostáva už len 1 deň.')
    choose 'Vyzdvihne ho za mňa iná osoba'
    click_button 'Pokračovať'

    fill_in 'Meno, priezvisko, titul', with: 'Ferko Mrkva', class: 'person'
    fill_in 'Rodné číslo', with: '123'

    fill_in 'Ulica a číslo', with: 'Pupavova 31'
    fill_in 'PSČ', with: '456'
    fill_in 'Obec', with: 'Bratislava - Karlova ves'

    fill_in 'Meno, priezvisko, titul', with: 'Jano Mrkva', class: 'authorized-person'
    fill_in 'Číslo občianskeho preukazu', with: '567'

    click_button 'Pokračovať'

    expect(page).to have_content('Meno: Ferko Mrkva')
    expect(page).to have_content('Rodné číslo: 123')
    expect(page).to have_content('Trvalý pobyt: Pupavova 31, 456 Bratislava - Karlova ves')
    expect(page).to have_content('Štátna príslušnosť: slovenská')

    expect(page).to have_content('Preukaz vyzdvihne splnomocnená osoba:')
    expect(page).to have_content('Meno: Jano Mrkva')
    expect(page).to have_content('Číslo občianskeho preukazu: 567')

    # TODO no way to check the checkbox
    # check 'Áno, túto vygenerovanú žiadosť som odoslal/a na úrad emailom a chcem pokračovať.'
    # click_button 'Dokončiť návod'
    # expect(page).to have_content('Počkajte na hlasovací preukaz')
  end

  scenario 'As a citizen I want to request voting permit by post after the deadline' do
    travel_to Date.new(2024, 5, 21)

    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Áno, mám trvalý pobyt v SR'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Termín na zaslanie žiadosti o hlasovací preukaz už uplynul.')
  end

  scenario 'As a citizen I want to request voting permit personally' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Áno, mám trvalý pobyt v SR'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Na túto možnosť ostáva ešte 19 dní.')
    choose 'Vyzdvihnem ho osobne na úrade'
    click_button 'Pokračovať'

    expect(page).to have_content('Prevzatie hlasovacieho preukazu osobne')
    expect(page).to have_content('Hlasovací preukaz vám vystavia na počkanie na obecnom úrade v mieste trvalého bydliska. Osobne si preukaz vybavíte najneskôr v posledný pracovný deň pred voľbami, počas pracovných hodín úradu.')
  end

  scenario 'As a non-SK citizen and SK resident I want to vote in Slovakia' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám občianstvo inej členskej krajiny EÚ'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    expect(page).to have_content('Museli ste požiadať o zapísanie do zoznamu voličov')
  end

  scenario 'As a non-SK citizen and non-SK resident I want to vote in Slovakia' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám občianstvo inej členskej krajiny EÚ'
    click_button 'Pokračovať'

    choose 'Nie'
    click_button 'Pokračovať'

    expect(page).to have_content('Nemôžete voliť na Slovensku')
  end

  scenario 'As a citizen I want to vote at home address' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Áno, mám trvalý pobyt v SR'
    click_button 'Pokračovať'

    choose 'Na Slovensku, v mieste trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Nepotrebujete nič vybavovať')
  end

  scenario 'As SK citizen with outside EU residency I want to vote in EP election' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Nie, mám trvalý pobyt mimo EÚ'
    click_button 'Pokračovať'

    expect(page).to have_content('Ak máte trvalý pobyt mimo EÚ, môžete voliť v ktoromkoľvek volebnom okrsku na Slovensku')
  end

  scenario 'As SK citizen with inside EU residency I want to vote in EP election' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám slovenské občianstvo'
    click_button 'Pokračovať'

    choose 'Nie, mám trvalý pobyt v inej členskej krajine EÚ'
    click_button 'Pokračovať'

    expect(page).to have_content('Ak máte trvalý pobyt v inej členskej krajine EÚ, môžete voliť iba v tejto krajine')
  end

  scenario 'As a foreigner I can\'t vote in EP election' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Mám občianstvo mimo EÚ'
    click_button 'Pokračovať'

    expect(page).to have_content('Vo voľbách do európskeho parlamentu nemôžete voliť')
  end

  scenario 'As a citizen I want to see subscription options when vote is not active' do
    allow(Apps::EpVoteApp::ApplicationForm).to receive(:active?).and_return(false)
    visit apps_ep_vote_app_application_forms_path

    expect(page).to have_content('Voľby do európskeho parlamentu sa už konali')
    expect(page).to have_content('Chcem dostávať upozornenia k voľbám')
  end
end
