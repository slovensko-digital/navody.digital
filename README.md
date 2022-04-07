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

### Setup VS Code Remote Containers

_Najjednoduchší spôsob rozbehania projektu. Úplne rovnako potom funguje v GitHub Codespace. [Link na ich docs](https://code.visualstudio.com/docs/remote/containers)_

#### Prerekvizity:

- `Linux` -> `docker` a `docker-compose 1.21+`
- `Windows/MacOS` -> `Docker Desktop 2.0+`
- Visual Studio Code
- Vo VS Code rozšírenie [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

#### Setup

- `cp .env.sample .env`
- Otvoriť projekt vo VS Code
- `View -> Command Palette`
- vyhľadať a vybrať `>Remote-Containers: Reopen in Container`

Prvýkrát sa musí postaviť docker image a vytvoriť docker kontajner, takže to môže s inštaláciou balíčkov trvať aj 5 minút. Ďalšie spustenia už potom trvajú rádovo pár sekúnd.

Vo VS Code je možné používať klasický linuxový terminál vo vnútri kontajnera alebo si vytvoriť `Run and Debug` konfiguráciu pre rails server, ktorá umožní používanie debugera,

### Spustenie:

- `bin/rails s`

_Stránka dostupná na http://localhost:3000_

### Test:

- `bin/rails db:setup`
- `bin/rake`

_Ten db:setup stačí zavolať iba raz. Pri opakovaných testoch stačí už iba `bin/rake`._
