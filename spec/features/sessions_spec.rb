require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  before(:each) do
    # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
    default_url_options[:host] = "localhost:3000"
    Capybara.default_host = "http://localhost:3000"
  end

  scenario 'As a visitor I want to see login options' do
    visit root_path
    click_link 'Prihlásiť'

    expect(page).to have_selector(:link_or_button, 'Prihlásiť sa cez Google')
    expect(page).to have_selector(:link_or_button, 'Prihlásiť sa e-mailom')
  end

  scenario 'As a visitor I want to be able to login using magic link' do
    OmniAuth.config.test_mode = false

    visit root_path
    click_link 'Prihlásiť'

    within 'form#login-email' do
      fill_in :email, with: 'foo@bar.com'
    end

    ActionMailer::Base.deliveries = []

    click_on 'Prihlásiť sa e-mailom'

    expect(ActionMailer::Base.deliveries.size).to eq 1

    mailer_email = ActionMailer::Base.deliveries.first
    email = Capybara::Node::Simple.new(mailer_email.body.to_s)
    magic_link = email.find('a')[:href]

    ActionMailer::Base.deliveries = []

    expect(magic_link).to match(auth_callback_url(:magiclink))

    expect(page).not_to have_link('Odhlásiť')

    visit magic_link

    within '.user-info' do
      expect(page).to have_text('foo@bar.com')
      expect(page).to have_link('Odhlásiť')
    end
  end

  scenario 'As a returning user I want to be able to login using magic link to my same account' do
    OmniAuth.config.test_mode = false

    create(:user, email: 'foo@bar.com')
    expect(User.count).to eq 1

    visit new_session_path

    within 'form#login-email' do
      fill_in :email, with: 'foo@bar.com'
    end

    ActionMailer::Base.deliveries = []

    click_on 'Prihlásiť sa e-mailom'

    expect(ActionMailer::Base.deliveries.size).to eq 1

    mailer_email = ActionMailer::Base.deliveries.first
    email = Capybara::Node::Simple.new(mailer_email.body.to_s)
    magic_link = email.find('a')[:href]

    visit magic_link

    within '.user-info' do
      expect(page).to have_text('foo@bar.com')
    end

    expect(User.count).to eq 1
  end

  scenario 'As a returning user I want to be able to login using magic link to my same account using email that has different character case' do
    OmniAuth.config.test_mode = false

    create(:user, email: 'foo@bar.com')
    expect(User.count).to eq 1

    visit new_session_path

    within 'form#login-email' do
      fill_in :email, with: 'FoO@bAr.cOm'
    end

    ActionMailer::Base.deliveries = []

    click_on 'Prihlásiť sa e-mailom'

    expect(ActionMailer::Base.deliveries.size).to eq 1

    mailer_email = ActionMailer::Base.deliveries.first
    email = Capybara::Node::Simple.new(mailer_email.body.to_s)
    magic_link = email.find('a')[:href]

    visit magic_link

    within '.user-info' do
      expect(page).to have_text('foo@bar.com')
    end

    expect(User.count).to eq 1
  end

  scenario 'As a visitor I dont want to be able to login using magic link from different session' do
    OmniAuth.config.test_mode = false

    visit root_path
    click_link 'Prihlásiť'

    within 'form#login-email' do
      fill_in :email, with: 'foo@bar.com'
    end

    ActionMailer::Base.deliveries = []

    click_on 'Prihlásiť sa e-mailom'

    expect(ActionMailer::Base.deliveries.size).to eq 1

    mailer_email = ActionMailer::Base.deliveries.first
    email = Capybara::Node::Simple.new(mailer_email.body.to_s)
    magic_link = email.find('a')[:href]

    expect(magic_link).to match(auth_callback_url(:magiclink))

    expect(page).not_to have_link('Odhlásiť')

    expire_cookies

    visit magic_link

    within '.user-info' do
      expect(page).not_to have_text('foo@bar.com')
      expect(page).not_to have_link('Odhlásiť')
      expect(page).to have_link('Prihlásiť')
    end
  end

  scenario 'As a visitor I want to be able to login using google' do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, {
      provider: 'google_oauth2',
      info: {
        email: 'foo@bar.com'
      }
    })

    visit root_path
    click_link 'Prihlásiť'
    click_link 'Prihlásiť sa cez Google'

    within '.user-info' do
      expect(page).to have_text('foo@bar.com')
      expect(page).to have_link('Odhlásiť')
    end
  end
end
