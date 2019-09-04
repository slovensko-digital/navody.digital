require 'rails_helper'
require_relative '../../../app/models/apps/ep_vote_app/application_form'

RSpec.feature "EP vote app", type: :feature do
  before do
    allow(Apps::EpVoteApp::ApplicationForm).to receive(:active?).and_return(true)
  end

  scenario 'As a citizen I want to request voting permit via post' do
    travel_to Date.new(2019, 5, 3)

    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Chcem ho dostať poštou'
    click_button 'Pokračovať'

    fill_in 'Meno, priezvisko, titul', with: 'Ferko Mrkva'
    fill_in 'Rodné číslo', with: '123'
    fill_in 'Štátna príslušnosť', with: 'ruská'
    click_button 'Pokračovať'

    fill_in 'Ulica a číslo', with: 'Pupavova 31'
    fill_in 'PSČ', with: '456'
    fill_in 'Obec', with: 'Bratislava - Karlova ves'
    click_button 'Pokračovať'

    choose 'Na adresu trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Meno: Ferko Mrkva')
    expect(page).to have_content('Rodné číslo: 123')
    expect(page).to have_content('Trvalý pobyt: Pupavova 31, 456 Bratislava - Karlova ves')
    expect(page).to have_content('Štátna príslušnosť: ruská')

    click_link 'pokračujte ďalej'
    expect(page).to have_content('Gratulujeme')
  end

  scenario 'As a citizen I want to request voting permit via post to a different address' do
    travel_to Date.new(2019, 5, 3)
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Chcem ho dostať poštou'
    click_button 'Pokračovať'

    fill_in 'Meno, priezvisko, titul', with: 'Ferko Mrkva'
    fill_in 'Rodné číslo', with: '123'
    fill_in 'Štátna príslušnosť', with: 'ruská'
    click_button 'Pokračovať'

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
    expect(page).to have_content('Štátna príslušnosť: ruská')

    expect(page).to have_content('Preukaz prosím zaslať na korešpondenčnú adresu: Konvalinkova 3, 456 Bratislava - Ruzinov, Slovensko')

    click_link 'pokračujte ďalej'
    expect(page).to have_content('Gratulujeme')
  end

  scenario 'As a citizen I want to request voting permit by post after the deadline' do
    travel_to Date.new(2019, 5, 4)

    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Chcem ho dostať poštou'
    click_button 'Pokračovať'

    expect(page).to have_content('Termín na zaslanie hlasovacieho preukazu poštou už uplynul')
  end

  scenario 'As a citizen I want to request voting permit personally' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Osobne si ho vyzdvihnem na úrade'
    click_button 'Pokračovať'

    expect(page).to have_content('Prevzatie hlasovacieho preukazu osobne')
  end

  scenario 'As a non-SK citizen I want to vote in Slovakia' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Nie'
    click_button 'Pokračovať'

    expect(page).to have_content('Hlasovanie občanov iného členského štátu EÚ na Slovensku')
  end


  scenario 'As a citizen I want to vote at home address' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'Na Slovensku, v mieste trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Hlasovanie v mieste trvalého bydliska')
  end

  scenario 'As a citizen I want to vote somewhere inside EU' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'V zahraničí, kde mám povolený pobyt'
    click_button 'Pokračovať'

    expect(page).to have_content('Hlasovanie v inom členskom štáte EÚ')
  end

  scenario 'As a citizen I want to vote somewhere outside EU' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Súhlasím a chcem začať'

    choose 'V zahraničí'
    click_button 'Pokračovať'

    expect(page).to have_content('Hlasovanie v zahraničí')
  end

  scenario 'As a citizen I want to see subscription options when vote is not active' do
    allow(Apps::EpVoteApp::ApplicationForm).to receive(:active?).and_return(false)
    visit apps_ep_vote_app_application_forms_path

    expect(page).to have_content('Voľby do Európskeho parlamentu sa už konali')
    expect(page).to have_content('Chcem dostávať upozornenia k voľbám')
  end
end
