Webdrivers::Chromedriver.update

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(options: { args: %w(headless disable-gpu disable-logging) })
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.configure do |config|
  config.default_max_wait_time = 2
  config.javascript_driver = :chrome
  config.server = :puma, { Silent: true }
end
