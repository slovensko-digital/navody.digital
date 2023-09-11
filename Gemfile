source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7.3'
gem 'rails-i18n'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'webpacker'

gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Gems for tracking the statuses of jobs
gem 'que'
gem 'que-web'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'jwt'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

gem 'pry-rails'

gem 'aws-sdk-rails'
gem "aws-sdk-s3", require: false
gem 'aws-sdk-cloudwatch'

gem 'rollbar'
gem 'oj' # needed by rollbar
gem 'nokogiri'

gem 'pg_search'
gem 'kaminari'
gem 'exception_handler'

gem 'premailer-rails'
gem 'clockwork'
gem 'sitemap_generator'

gem 'validate_url'

gem 'http'

# sendinblue V3
gem 'sib-api-v3-sdk'
gem 'recaptcha'
gem 'friendly_id'

gem 'invisible_captcha'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '4.0.2'
  gem 'rspec_junit_formatter'
  gem 'faker'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'letter_opener_web'
  gem 'wdm', '~> 0.1.0', platforms: [:mingw, :mswin, :x64_mingw]
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', "~> 3.39.2"
  gem 'show_me_the_cookies'
  gem 'selenium-webdriver', "~> 4.9.0"
  gem "webdrivers", "= 5.3.0"
  gem 'simplecov', '< 0.18' # https://github.com/codeclimate/test-reporter/issues/413
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'hirb'
