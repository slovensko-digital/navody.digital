require 'rails_helper'

RSpec.feature "EP vote app", type: :feature do
  scenario 'As a citizen I want to request voting permit' do
    visit apps_ep_vote_app_application_forms_path

    click_button 'Chcem začať'

    choose 'Na Slovensku, mimo trvalého bydliska.'
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

    click_link 'Pokračovať'
    expect(page).to have_content('Gratulujeme')
  end
end
