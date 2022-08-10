require 'csv'

class SeedCodeListsJob < ApplicationJob
  queue_as :default

  def perform
    seed_municipalities
    seed_countries
    seed_currencies
    seed_courts
  end

  def seed_municipalities(downloader: Faraday, file_path: Rails.root + 'obce.csv')
    CSV.foreach(file_path, headers: true, col_sep: '|') do |municipality|
      CodeList::Municipality.find_or_create_by({
        identifier: municipality['code'],
        value: municipality['officialTitle']
      })
    end
  end

  def seed_countries(downloader: Faraday, file_path: Rails.root + 'krajiny.csv')
    CSV.foreach(file_path, headers: true, col_sep: '|') do |country|
      CodeList::Country.find_or_create_by({
        identifier: country['code'],
        value: country['officialTitle']
      })
    end
  end

  def seed_currencies
    currencies = [
      {
        'identifier': 1,
        'value': 'Sk',
        'code': 'Sk'
      },
      {
        'identifier': 6,
        'value': 'EUR',
        'code': 'EUR'
      },
      {
        'identifier': 7,
        'value': 'bulharský lev',
        'code': 'BGN'
      },
      {
        'identifier': 8,
        'value': 'dánska koruna',
        'code': 'DKK'
      },
      {
        'identifier': 9,
        'value': 'lotyšský lats',
        'code': 'LVL'
      },
      {
        'identifier': 10,
        'value': 'litovský litas',
        'code': 'LTL'
      },
      {
        'identifier': 11,
        'value': 'maltská líra',
        'code': 'MTL'
      },
      {
        'identifier': 12,
        'value': 'švédska koruna',
        'code': 'SEK'
      },
      {
        'identifier': 13,
        'value': 'anglická libra',
        'code': 'GBP'
      },
      {
        'identifier': 14,
        'value': 'rumunský lei',
        'code': 'RON'
      },
      {
        'identifier': 15,
        'value': 'zlotý',
        'code': 'PLN'
      },
      {
        'identifier': 16,
        'value': 'forint',
        'code': 'HUF'
      },
      {
        'identifier': 17,
        'value': 'česká koruna',
        'code': 'CZK'
      },
      {
        'identifier': 18,
        'value': 'cyperská libra',
        'code': 'CYP'
      }
    ]

    currencies.each do |currency|
      CodeList::Currency.find_or_create_by(currency)
    end
  end

  def seed_courts
    courts = [
      {
        'name': 'Bratislava I',
        'identifier': 2,
        'code': 'B',
        'street': 'Záhradnícka',
        'number': '10',
        'postal_code': '81244',
        'municipality': 'Bratislava I'
      },
      {
        'name': 'Banská Bystrica',
        'identifier': 3,
        'code': 'S',
        'street': 'Skuteckého',
        'number': '28',
        'postal_code': '97559',
        'municipality': 'Banská Bystrica'
      },
      {
        'name': 'Košice I',
        'identifier': 4,
        'code': 'V',
        'street': 'Štúrova',
        'number': '29',
        'postal_code': '04160',
        'municipality': 'Košice I'
      },
      {
        'name': 'Žilina',
        'identifier': 5,
        'code': 'L',
        'street': 'Hviezdoslavova',
        'number': '28',
        'postal_code': '01059',
        'municipality': 'Žilina'
      },
      {
        'name': 'Trenčín',
        'identifier': 6,
        'code': 'R',
        'street': 'Piaristická',
        'number': '27',
        'postal_code': '91180',
        'municipality': 'Trenčín'
      },
      {
        'name': 'Trnava',
        'identifier': 7,
        'code': 'T',
        'street': 'Hlavná',
        'number': '49',
        'postal_code': '91783',
        'municipality': 'Trnava'
      },
      {
        'name': 'Prešov',
        'identifier': 8,
        'code': 'P',
        'street': 'Grešova',
        'number': '3',
        'postal_code': '08042',
        'municipality': 'Prešov'
      },
      {
        'name': 'Nitra',
        'identifier': 9,
        'code': 'N',
        'street': 'Štúrova',
        'number': '9',
        'postal_code': '94968',
        'municipality': 'Nitra'
      },
    ]

    courts.each do |court|
      CodeList::Court.find_or_create_by(court)
    end
  end
end
