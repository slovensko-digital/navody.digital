# Návody.digital

[![CircleCI](https://circleci.com/gh/slovensko-digital/navody.digital.svg?style=svg)](https://circleci.com/gh/slovensko-digital/navody.digital)
[![Test Coverage](https://api.codeclimate.com/v1/badges/78658a3b4aa6d98ce263/test_coverage)](https://codeclimate.com/github/slovensko-digital/navody.digital/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/78658a3b4aa6d98ce263/maintainability)](https://codeclimate.com/github/slovensko-digital/navody.digital/maintainability)

### Deployment
Master ide automaticky na https://staging.navody.digital/

### Setup

#### OSX (homebrew)
 - `brew install postgresql`
 - `brew services start postgresql`
 - `bin/setup`
 - `bin/rails s`

#### Test Enviroment

Na spustenie system testov:

 - `bin/rails db:create`
 - `bin/rails db:setup`
 - `bin/rake`

### Neprogramátorské úlohy
Wishlist ďalších návodov na spracovanie a editovanie, eventy a ďalší progress nájdete na https://trello.com/b/4tkVI6vr/n%C3%A1vodydigital

