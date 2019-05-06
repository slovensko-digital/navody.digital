require 'rails_helper'

RSpec.feature 'Admin Journeys', type: :feature do

  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"

    page.driver.browser.authorize 'admin', 'admin'
  end

  def position_for_step(step_index)
    find(:xpath, "//*[@id=\"main-content\"]/table/tbody/tr[#{step_index}]/td[1]").text
  end

  scenario 'As an admin I want to reposition steps' do
    journey = create(:journey)
    create(:step, journey: journey, position: 0)
    create(:step, journey: journey, position: 0)

    visit admin_journey_steps_path(journey)

    expect(position_for_step(1)).to eq('0')
    expect(position_for_step(2)).to eq('0')

    click_link 'Reposition'

    expect(position_for_step(1)).to eq('1')
    expect(position_for_step(2)).to eq('2')
  end

  scenario 'As an admin I want new step to have pre filled position when there are already some steps' do
    journey2 = create(:journey)
    create(:step, journey: journey2, position: 1)
    create(:step, journey: journey2, position: 2)

    visit new_admin_journey_step_path(journey2)

    expect(find(:xpath, '//*[@id="step_position"]').value).to eq('3')
  end
end
