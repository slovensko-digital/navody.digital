# Návody.digital

[![Slovensko.Digital CI](https://github.com/slovensko-digital/navody.digital/workflows/Slovensko.Digital%20CI/badge.svg)](https://github.com/slovensko-digital/navody.digital/actions/workflows/slovensko_digital_ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/78658a3b4aa6d98ce263/maintainability)](https://codeclimate.com/github/slovensko-digital/navody.digital/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/78658a3b4aa6d98ce263/test_coverage)](https://codeclimate.com/github/slovensko-digital/navody.digital/test_coverage)

### Deployment

Master ide automaticky na [staging.navody.digital](https://staging.navody.digital)

### Setup

#### OSX (homebrew)

 - `brew install postgresql`
 - `brew services start postgresql`
 - `bundle install`
 - `yarn install`
 - `cp .env.sample .env`
 - `bin/setup`
 - `bin/rails s`

#### Test

 - `bin/rails db:setup`
 - `bin/rake`

### Neprogramátorské úlohy

- [Wishlist ďalších návodov na spracovanie a úpravu, eventy a ďalší progress](https://trello.com/b/4tkVI6vr/n%C3%A1vodydigital)
