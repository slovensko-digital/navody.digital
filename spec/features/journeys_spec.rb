require 'rails_helper'

RSpec.feature "Journeys", type: :feature do

  def sign_in(user)
    OmniAuth.config.test_mode = false
    visit new_session_path

    within 'form#login-email' do
      fill_in :email, with: user.email
    end

    clear_mail_deliveries

    click_on 'Prihlásiť sa e-mailom'

    visit link_in_last_email
  end

  let!(:user) { create(:user, email: 'someone@example.com') }
  let!(:journey) { create(:journey) }
  let!(:step1) { create(:step, journey: journey) }
  let!(:step2) { create(:step, journey: journey, app_url: faqs_url(host: 'http://localhost:3000'), type: 'ExternalAppStep') }
  let!(:task) { create(:task, step: step1) }
  let!(:blank_journey) { create(:journey, published_status: "BLANK", description: nil) }

  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"
  end

  scenario 'As an anonymous user I want to read a journey' do
    visit journey_path(journey)
    expect(page).to have_content('Aby ste na nič nezabudli')
    expect(page).to have_content(/Aktualizované: \d\d.\d\d.\d{4}/)

    click_link 'Ďalší krok'
    expect(page).to have_content(step1.title)
  end

  scenario 'As an anonymous user I want to start an app' do
    visit journey_step_path(journey, step2)

    click_link 'Požiadať elektronicky'
    expect(page.current_url).to eq(faqs_url)
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

end
