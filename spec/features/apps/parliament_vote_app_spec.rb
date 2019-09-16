require 'rails_helper'
require_relative '../../../app/models/apps/ep_vote_app/application_form'

def start
  visit apps_parliament_vote_app_application_forms_path
  click_button 'Súhlasím a chcem začať'
end

RSpec.feature "Parliament vote app", type: :feature do
  before do
    allow(Apps::ParliamentVoteApp::ApplicationForm).to receive(:active?).and_return(true)
  end

  scenario 'As a citizen I want to request voting permit via post' do
    travel_to Date.new(2020, 1, 1)
    start

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
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
    travel_to Date.new(2020, 1, 1)
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
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
    travel_to Date.new(2020, 5, 4)
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Chcem ho dostať poštou'
    click_button 'Pokračovať'

    expect(page).to have_content('Termín na zaslanie hlasovacieho preukazu poštou už uplynul')
  end

  scenario 'As a citizen I want to request voting permit personaly' do
    travel_to Date.new(2020, 5, 4)
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Osobne si ho vyzdvihnem na úrade'
    click_button 'Pokračovať'

    expect(page).to have_content('Prevzatie hlasovacieho preukazu osobne')
  end

  scenario 'As a citizen I want to request voting permit via authorized person' do
    travel_to Date.new(2020, 5, 4)
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Na Slovensku, mimo trvalého bydliska'
    click_button 'Pokračovať'

    choose 'Vyzdvihne ho splnomocnena osoba'
    click_button 'Pokračovať'

    expect(page).to have_content('Prevzatie hlasovacieho preukazu splnomocnenou osobou')
  end

  scenario 'As a citizen I want to vote at home address' do
    travel_to Date.new(2020, 1, 1)
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Na Slovensku, v mieste trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Hlasovanie v mieste trvalého bydliska')
  end

  scenario 'As a citizen I want to vote in foregin country with permanent residency in Slovakia' do
    travel_to Date.new(2020, 1, 1)
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'V zahraničí'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    expect(page).to have_content('Hlasovanie v zahraničí')
    expect(page).to have_content('ziadost na samospravu')
  end

  scenario 'As a citizen I want to vote in foregin country with permanent residency outside Slovakia' do
    travel_to Date.new(2020, 1, 1)
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'V zahraničí'
    click_button 'Pokračovať'

    choose 'Nie'
    click_button 'Pokračovať'

    expect(page).to have_content('Hlasovanie v zahraničí')
    expect(page).to have_content('ziadost na min vnutra')
  end

  scenario "As a non-SK citizen I can't vote in parliament votes" do
    start
    choose 'Nie'
    click_button 'Pokračovať'

    expect(page).to have_content('Ľutujeme ale v parlamentných volbach voliť nemôžeš.')
  end

  scenario 'As a citizen I want to see subscription options when vote is not active' do
    allow(Apps::ParliamentVoteApp::ApplicationForm).to receive(:active?).and_return(false)
    visit apps_parliament_vote_app_application_forms_path

    expect(page).to have_content('Voľby do parlamentu sa už konali')
    expect(page).to have_content('Chcem dostávať upozornenia k voľbám')
  end
end
