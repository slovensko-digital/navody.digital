# Návody.digital

[![Slovensko.Digital CI](https://github.com/slovensko-digital/navody.digital/workflows/Slovensko.Digital%20CI/badge.svg)](https://github.com/slovensko-digital/navody.digital/actions/workflows/slovensko_digital_ci.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/78658a3b4aa6d98ce263/maintainability)](https://codeclimate.com/github/slovensko-digital/navody.digital/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/78658a3b4aa6d98ce263/test_coverage)](https://codeclimate.com/github/slovensko-digital/navody.digital/test_coverage)

### Deployment

Master ide automaticky na [staging.navody.digital](https://staging.navody.digital)

### Neprogramátorské úlohy

- [Wishlist ďalších návodov na spracovanie a úpravu, eventy a ďalší progress](https://trello.com/b/4tkVI6vr/n%C3%A1vodydigital)

### Setup OSX (homebrew)

 - `brew install postgresql`
 - `brew services start postgresql`
 - `bundle install`
 - `yarn install`
 - `cp .env.sample .env`
 - `bin/setup`

### Setup VS Code [Remote Containers](https://code.visualstudio.com/docs/remote/containers)

#### Prerekvizity:

- `Linux` -> `docker` a `docker-compose 1.21+`
- `Windows/MacOS` -> `Docker Desktop 2.0+`
- Visual Studio Code
- Vo VS Code rozšírenie [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

#### Setup

- Otvoriť projekt vo VS Code
- `View -> Command Palette`
- vyhľadať a vybrať `>Remote-Containers: Reopen in Container`
- `cp .env.sample .env`
- Seed databázy `bin/rails db:seed:replant`

Prvýkrát sa musí postaviť docker image a vytvoriť docker kontajner, takže to môže s kompilovaním Ruby a inštaláciou balíčkov trvať aj 10 minút. Ďalšie spustenia už potom trvajú rádovo pár sekúnd.

Vo VS Code je možné používať klasický linuxový terminál vo vnútri kontajnera alebo si vytvoriť `Run and Debug` konfiguráciu pre rails server, ktorá umožní používanie debugera.

Emaily odoslané aplikáciou je možné pozrieť na adrese [http://localhost:3000/letter_opener](http://localhost:3000/letter_opener)

### Spustenie:

- `bin/rails s`

Aplikácia štandardne beží na [http://localhost:3000](http://localhost:3000)

### Test:

- `bin/rake`

