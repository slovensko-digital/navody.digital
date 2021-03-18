# https://stackoverflow.com/questions/598933/how-do-i-change-the-default-www-example-com-domain-for-testing-in-rails
Capybara.default_host = "http://localhost:3000"

RSpec.configure do |c|
  c.before(:each, type: :feature) do
    default_url_options[:host] = "localhost:3000"
  end
end
