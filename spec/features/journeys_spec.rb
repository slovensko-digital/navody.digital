require 'rails_helper'

RSpec.feature "Journeys", type: :feature do
  let!(:user) { create(:user, email: 'someone@example.com') }
  let!(:journey) { create(:journey) }
  let!(:step1) { create(:step, journey: journey) }
  let!(:step2) { create(:step, journey: journey, app_url: faqs_url(host: 'http://localhost:3000'), type: 'ExternalAppStep') }
  let!(:task) { create(:task, step: step1) }
  let!(:blank_journey) { create(:journey, published_status: "BLANK", description: nil) }
  let!(:url_only_journey) { create(:journey, published_status: "URL_ONLY", description: "this is the url only journey") }


  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"
  end

  scenario 'As an anonymous user I want to read a journey' do
    visit journey_path(journey)
    expect(page).to have_content('Aby ste na nič nezabudli')

    click_link 'Ďalší krok'
    expect(page).to have_content(step1.title)
  end

  scenario 'As an anonymous user I want to start an app' do
    visit journey_step_path(journey, step2)

    click_link 'Požiadať elektronicky'
    expect(page.current_url).to eq(faqs_url)
  end

  scenario 'As an anonymous user I cannot see my journeys in process' do
    visit user_journeys_path

    expect(page).to have_content('Prihláste sa do svojho účtu')
    expect(page.current_url).to eq(new_session_url)
  end

  scenario 'As a logged in user I want to check my journeys in process' do
    sign_in(user)
    visit user_journeys_path

    expect(page).to have_content('Nemáte žiadne aktuálne životné situácie')
    expect(page).to have_content('Moje životné situácie')
  end

  scenario 'As a logged in user I want mark a step as done' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    click_link 'Označiť ako vybavené'

    expect(page).to have_content('Vybavené!')
  end

  scenario 'As a logged in user I want mark a step as not done' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    click_link 'Označiť ako vybavené'
    click_link 'označiť ako nevybavený'

    expect(page).to have_content('Označiť ako vybavené')
  end

  scenario 'As a logged in user I want restart a journey' do
    sign_in(user)
    visit journey_step_path(journey, step1)

    click_link 'Označiť ako vybavené'
    click_link 'Začať celý návod odznovu'
    expect(page).not_to have_content('Začať celý návod odznovu')

    click_link 'Ďalší krok'
    expect(page).to have_content('Označiť ako vybavené')
  end

  scenario 'As a logged in user I want to mark a task as done' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    check task.title
    element = find "#form_task_#{task.id}"
    page.submit(element)

    visit journey_step_path(journey, step1)

    expect(page).to have_checked_field(task.title)
  end

  scenario 'As a logged in user I want to mark a done task as undone' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    check task.title
    element = find "#form_task_#{task.id}"
    page.submit(element)

    visit journey_step_path(journey, step1)

    uncheck task.title
    element = find "#form_task_#{task.id}"
    page.submit(element)

    expect(page).not_to have_checked_field(task.title)
  end

  scenario 'As a logged in user I want mark a step as done and check my journeys in process' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    click_link 'Označiť ako vybavené'

    expect(page).to have_content('Vybavené!')

    visit user_journeys_path
    expect(page).to have_content(journey.title)
  end

  scenario 'As a logged in user I want mark a step as not done and check my journeys in process' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    click_link 'Označiť ako vybavené'
    click_link 'označiť ako nevybavený'

    expect(page).to have_content('Označiť ako vybavené')

    visit user_journeys_path
    expect(page).to have_content(journey.title)
  end

  scenario 'As a logged in user I want restart a journey and check my journeys in process' do
    sign_in(user)
    visit journey_step_path(journey, step1)

    click_link 'Označiť ako vybavené'
    click_link 'Začať celý návod odznovu'
    expect(page).not_to have_content('Začať celý návod odznovu')

    click_link 'Ďalší krok'
    expect(page).to have_content('Označiť ako vybavené')

    visit user_journeys_path
    expect(page).to have_content('Nemáte žiadne aktuálne životné situácie')
  end

  scenario 'As a logged in user I want to mark a task as done and check my journeys in process' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    check task.title
    element = find "#form_task_#{task.id}"
    page.submit(element)

    visit journey_step_path(journey, step1)

    expect(page).to have_checked_field(task.title)

    visit user_journeys_path
    expect(page).to have_content(journey.title)
  end

  scenario 'As a logged in user I want to mark a done task as undone and check my journeys in process' do
    sign_in(user)
    visit journey_path(journey)

    click_link 'Ďalší krok'
    check task.title
    element = find "#form_task_#{task.id}"
    page.submit(element)

    visit journey_step_path(journey, step1)

    uncheck task.title
    element = find "#form_task_#{task.id}"
    page.submit(element)

    expect(page).not_to have_checked_field(task.title)

    visit user_journeys_path
    expect(page).to have_content(journey.title)
  end

  scenario 'As an anonymous user I want to check if blank journey displays correctly' do
    visit journey_path(blank_journey)

    expect(page).to have_content('Na tomto návode ešte len pracujeme')
    expect(page).to have_content(blank_journey.title)
  end

  scenario 'As a logged user I want to check if blank journey displays correctly' do
    sign_in(user)
    visit journey_path(blank_journey)

    expect(page).to have_content('Na tomto návode ešte len pracujeme')
    expect(page).to have_content(blank_journey.title)
  end

  scenario 'As an anonymous user I want to check if the url_only journey displays correctly' do
    sign_in(user)
    visit journey_path(url_only_journey)

    expect(page).to have_content('this is the url only journey')
    expect(page).to have_content(url_only_journey.title)
  end

  scenario 'As user I want to check if last_check date is visible if old enough' do
    checked_journey = create(:journey, last_checked_on: Date.new(2020, 01, 23))
    checked_journey_step = create(:step, journey: checked_journey)

    visit journey_path(journey)
    expect(page).to_not have_content('Aktualizované')

    visit journey_step_path(journey, step1)
    expect(page).to_not have_content('Aktualizované')

    visit journey_path(checked_journey)
    expect(page).to have_content('Aktualizované')

    visit journey_step_path(checked_journey, checked_journey_step)
    expect(page).to have_content('Aktualizované')
  end

  scenario 'As user I do not want to see last_check still fresh' do
    checked_journey = create(:journey, last_checked_on: 2.months.ago)
    checked_journey_step = create(:step, journey: checked_journey)

    visit journey_path(checked_journey)
    expect(page).not_to have_content('Aktualizované')

    visit journey_step_path(checked_journey, checked_journey_step)
    expect(page).not_to have_content('Aktualizované')
  end
end
