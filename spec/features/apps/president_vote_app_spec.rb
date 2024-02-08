require 'rails_helper'
require_relative '../../../app/models/apps/president_vote_app/application_form'

def start
  visit apps_president_vote_app_application_forms_path
  click_button 'Súhlasím a chcem začať'
end

RSpec.feature "President vote app", type: :feature do
  before do
    travel_to Apps::PresidentVoteApp::ApplicationForm::FIRST_ROUND_DATE - 2.months
  end

  scenario 'As a citizen I want to vote in a different voting district in first round' do
    start

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    check 'apps_president_vote_app_application_form[place_first_round]'
    click_button 'Pokračovať'

    expect(page).to have_content('Potrebujete požiadať o hlasovací preukaz pre prvé kolo volieb')
    expect(page).to have_content('Aby ste mohli v deň volieb voliť mimo vášho trvalého bydliska, musíte požiadať vašu obec o vydanie hlasovacieho preukazu – osobne alebo elektronicky. Hlasovací preukaz vás oprávňuje voliť z ktoréhokoľvek volebného okrsku v SR.')
    expect(page).to have_content('Ako prevezmete hlasovací preukaz?')
    expect(page).to have_content('Nechám si ho poslať poštou')
    expect(page).to have_content('Vyzdvihne ho za mňa iná osoba')
    expect(page).to have_content('Vyzdvihnem ho osobne na úrade')
  end

  scenario 'As a citizen I want to vote in a different voting district in second round' do
    start

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    check 'apps_president_vote_app_application_form[place_second_round]'
    click_button 'Pokračovať'

    expect(page).to have_content('Potrebujete požiadať o hlasovací preukaz pre druhé kolo volieb')
    expect(page).to have_content('Aby ste mohli v deň volieb voliť mimo vášho trvalého bydliska, musíte požiadať vašu obec o vydanie hlasovacieho preukazu – osobne alebo elektronicky. Hlasovací preukaz vás oprávňuje voliť z ktoréhokoľvek volebného okrsku v SR.')
    expect(page).to have_content('Ako prevezmete hlasovací preukaz?')
    expect(page).to have_content('Nechám si ho poslať poštou')
    expect(page).to have_content('Vyzdvihne ho za mňa iná osoba')
    expect(page).to have_content('Vyzdvihnem ho osobne na úrade')
  end

  scenario 'As a citizen I want to vote in a different voting district in both rounds' do
    start

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    check 'apps_president_vote_app_application_form[place_first_round]'
    check 'apps_president_vote_app_application_form[place_second_round]'
    click_button 'Pokračovať'

    expect(page).to have_content('Potrebujete požiadať o hlasovací preukaz pre obe kolá volieb')
    expect(page).to have_content('Aby ste mohli v deň volieb voliť mimo vášho trvalého bydliska, musíte požiadať vašu obec o vydanie hlasovacieho preukazu – osobne alebo elektronicky. Hlasovací preukaz vás oprávňuje voliť z ktoréhokoľvek volebného okrsku v SR.')
    expect(page).to have_content('Ako prevezmete hlasovací preukaz?')
    expect(page).to have_content('Nechám si ho poslať poštou')
    expect(page).to have_content('Vyzdvihne ho za mňa iná osoba')
    expect(page).to have_content('Vyzdvihnem ho osobne na úrade')
  end

  scenario 'As a citizen I want to vote in a different voting district and it is already past first round' do
    travel_to Apps::PresidentVoteApp::ApplicationForm::FIRST_ROUND_DATE + 8.day
    start

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    expect(page).to have_content('Prvé kolo sa už konalo')
    choose 'Mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_content('Potrebujete požiadať o hlasovací preukaz pre druhé kolo volieb')
    expect(page).to have_content('Aby ste mohli v deň volieb voliť mimo vášho trvalého bydliska, musíte požiadať vašu obec o vydanie hlasovacieho preukazu – osobne alebo elektronicky. Hlasovací preukaz vás oprávňuje voliť z ktoréhokoľvek volebného okrsku v SR.')
    expect(page).to have_content('Ako prevezmete hlasovací preukaz?')
    expect(page).to have_content('Nechám si ho poslať poštou')
    expect(page).to have_content('Vyzdvihne ho za mňa iná osoba')
    expect(page).to have_content('Vyzdvihnem ho osobne na úrade')
  end

  scenario 'As a citizen I want to request voting permit personally after the deadline' do
    travel_to Apps::PresidentVoteApp::ApplicationForm::FIRST_ROUND_DATE - 2.day
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    check 'apps_president_vote_app_application_form[place_first_round]'
    click_button 'Pokračovať'

    expect(page).to have_field('Vyzdvihne ho za mňa iná osoba', disabled: true)
    expect(page).to have_field('Vyzdvihnem ho osobne na úrade', disabled: false)
  end

  scenario 'As a citizen I want to request voting permit by authorized person after the deadline' do
    travel_to Apps::PresidentVoteApp::ApplicationForm::FIRST_ROUND_DATE + 1.day
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_field('Vyzdvihne ho za mňa iná osoba', disabled: true)
  end

  scenario 'As a citizen I want to request voting permit by post after the deadline' do
    travel_to Apps::PresidentVoteApp::ApplicationForm::FIRST_ROUND_DATE + 1.day
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Mimo trvalého bydliska'
    click_button 'Pokračovať'

    expect(page).to have_field('Nechám si ho poslať poštou', disabled: true)
  end

  scenario 'As a citizen I want to request voting permit personally' do
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    check 'apps_president_vote_app_application_form[place_first_round]'
    click_button 'Pokračovať'

    choose 'Vyzdvihnem ho osobne'
    click_button 'Pokračovať'

    expect(page).to have_content('Prevzatie hlasovacieho preukazu osobne')
  end

  scenario 'As a citizen I want to request voting permit via authorized person' do
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    check 'apps_president_vote_app_application_form[place_first_round]'
    check 'apps_president_vote_app_application_form[place_second_round]'
    click_button 'Pokračovať'

    choose 'Vyzdvihne ho za mňa iná osoba'
    click_button 'Pokračovať'

    fill_in 'Meno, priezvisko, titul', with: 'Ferko Mrkva', class: 'person'
    fill_in 'Rodné číslo', with: '600101/1973', class: 'person'
    fill_in 'Ulica', with: 'Pupavova 31'
    fill_in 'PSČ', with: '456'
    fill_in 'Obec', with: 'Bratislava - Karlova ves'
    fill_in 'Meno, priezvisko, titul', with: 'Jarko Mrkva', class: 'authorized-person'
    fill_in 'Číslo občianskeho preukazu', with: '567', class: 'authorized-person'
    click_button 'Pokračovať'

    expect(page).to have_content('Meno: Ferko Mrkva')
    expect(page).to have_content('Rodné číslo: 600101/1973')
    expect(page).to have_content('Trvalý pobyt: Pupavova 31, 456 Bratislava - Karlova ves')
    expect(page).to have_content("Preukaz vyzdvihne splnomocnená osoba:\r \r Meno: Jarko Mrkva\r Číslo občianskeho preukazu: 567")

    check 'Poslal/a som žiadosť zo svojho emailu na úrad'
  end

  scenario 'As a citizen I want to vote at home address' do
    start
    choose 'Áno'
    click_button 'Pokračovať'

    choose 'Áno'
    click_button 'Pokračovať'

    click_button 'Pokračovať'

    expect(page).to have_content('Nepotrebujete nič vybavovať')
  end

  scenario "As a non-SK citizen I can't vote in president votes" do
    start
    choose 'Nie'
    click_button 'Pokračovať'

    expect(page).to have_content('môžu voliť len občania Slovenskej republiky.')
  end

  scenario 'As a citizen I want to see subscription options when vote is not active' do
    travel_to Apps::PresidentVoteApp::ApplicationForm::FIRST_ROUND_DATE + 15.day
    visit apps_president_vote_app_application_forms_path

    expect(page).to have_content('Prezidentské voľby sa už konali')
    expect(page).to have_content('Chcem dostávať upozornenia k voľbám')
  end
end
