class NotificationSubscription < ApplicationRecord
  self.inheritance_column = 'type2' # change

  TYPES = {
    'EpApplicationFormSubscription' => {
      label: 'Chcem dostávať notifikácie k hlasovaciemu preukazu a voľbám',
      hint: 'Zašleme Vám upozornenie chvíľu pred vypršaním lehoty, aby ste sa uistili, že máte hlasovací preukaz. Taktiež Vám zašleme informačný email pred týmito a ďaľšími voľbami.',
    },
    'VoteSubscription' => {
      label: 'Chcem dostávať upozornenia k voľbám',
      hint: 'Zašleme Vám správu s praktickými informáciami pred týmito a ďaľšími voľbami.',
    },
    'NextVoteSubscription' => {
      label: 'Chcem dostávať notifikácie k ďalším voľbám',
      hint: 'Zašleme Vám upozornenie pred ďaľšími voľbami, aby ste sa mohli pripraviť.',
    },
    'NewsletterSubscription' => {
      label: 'Chcem odoberať pravidelné novinky Návody.Digital',
      hint: 'Ak chcete vedieť o ďalších zlepšovákoch, ktoré pripravujeme, zvoľte si aj túto možnosť. Neposielame žiadny spam, bude to užitočné a len raz za čas.',
    },
  }

  belongs_to :user, optional: true

  def confirm
    self.confirmed_at = Time.now.utc unless self.confirmed_at
    save
  end
end
