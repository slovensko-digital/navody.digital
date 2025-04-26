require 'rails_helper'

RSpec.feature 'Admin Law Links', type: :feature do

  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"

    page.driver.browser.authorize 'admin', 'admin'
  end

  def position_for_step(step_index)
    find(:xpath, "//*[@id=\"main-content\"]/table/tbody/tr[#{step_index}]/td[1]").text
  end

  scenario 'As an admin I want to create Law link without breaking anything', skip: true do
    journey = create(:journey)

    visit admin_journeys_path(journey)

    click_link 'Law links (0)'
    click_link 'New Journey Legal Definition'
    fill_in 'journey_legal_definition_link', with: 'https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/2012/397/20130101'
    click_button 'Vytvoriť Journey legal definition'
    expect(page).to have_content('SK/ZZ/2012/397/20130101')

    visit admin_journeys_path(journey)
    expect(page).to have_link('Law links (1)')
    click_link('Edit')
    expect(page).to have_content('There is a problem')
  end
end
