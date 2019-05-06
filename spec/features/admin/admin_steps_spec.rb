require 'rails_helper'

RSpec.feature 'Admin Steps', type: :feature do

  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"

    page.driver.browser.authorize 'admin', 'admin'
  end

  def position_for_task(task_index)
    find(:xpath, "//*[@id=\"main-content\"]/table/tbody/tr[#{task_index}]/td[1]").text
  end

  scenario 'As an admin I want to reposition tasks' do
    step = create(:step)
    create(:task, step: step, position: 0)
    create(:task, step: step, position: 0)

    visit admin_journey_step_tasks_path(step.journey, step)

    expect(position_for_task(1)).to eq('0')
    expect(position_for_task(2)).to eq('0')

    click_link 'Reposition'

    expect(position_for_task(1)).to eq('1')
    expect(position_for_task(2)).to eq('2')
  end

  scenario 'As an admin I want new task to have pre filled position when there are already some tasks' do
    step = create(:step)
    create(:task, step: step, position: 1)
    create(:task, step: step, position: 2)

    visit new_admin_journey_step_task_path(step.journey, step)

    expect(find(:xpath, '//*[@id="task_position"]').value).to eq('3')
  end
end
