require 'rails_helper'

RSpec.feature "Journeys", type: :feature do

  def sign_in(user)
    OmniAuth.config.test_mode = false
    visit new_session_path

    within 'form#login-email' do
      fill_in :email, with: user.email
    end

    ActionMailer::Base.deliveries = []
    click_on 'Prihlásiť sa e-mailom'
    mailer_email = ActionMailer::Base.deliveries.first
    email = Capybara::Node::Simple.new(mailer_email.body.to_s)
    magic_link = email.find('a')[:href]
    visit magic_link
  end

  let!(:user) { create(:user, email: 'someone@example.com') }
  let!(:journey) { create(:journey) }
  let!(:step1) { create(:step, journey: journey) }
  let!(:step2) { create(:step, journey: journey) }

  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"
  end

  scenario 'A Journey clicked by an unknown user' do
    visit journey_path(journey)

    expect(page).to have_link('Začať vybavovať')
  end

  scenario 'A journey clicked by user who has not started the journey yet' do
    sign_in(user)
    visit journey_path(journey)

    expect(page).to have_link('Začať vybavovať')
  end

  scenario 'A journey clicked by user who has started the journey already' do
    user_journey = create(:user_journey, user: user, journey: journey)
    user_step = create(:user_step, user_journey: user_journey, step: step1)

    sign_in(user)
    visit journey_path(journey)

    expect(page).not_to have_link('Začať vybavovať')
  end
end
