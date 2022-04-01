Webdrivers::Chromedriver.update

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(options: { args: %w(headless disable-gpu disable-logging no-sandbox) })
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.configure do |config|
  config.default_max_wait_time = 2
  config.javascript_driver = :chrome
  config.server = :puma, { Silent: true }

  # https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
  config.default_host = "http://localhost:3000"
end

RSpec.configure do |c|
  c.before(:each, type: :feature) do
    default_url_options[:host] = "localhost:3000"
  end
end
