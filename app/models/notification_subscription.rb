class NotificationSubscription < ApplicationRecord
  self.inheritance_column = 'type2' # change

  # NOTE: When adding new subscription type, do not forget to create corresponding contact list with exactly matching name in marketing service
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
      hint: 'Ak chcete vedieť o ďalších zlepšovákoch, ktoré pripravujeme, zvoľte si túto možnosť. Neposielame žiadny spam, bude to užitočné a len raz za čas.',
    },
    'BlankJourneySubscription' => {
      label: 'Chcem odoberať informácie k tomuto návodu',
      hint: 'Zašleme Vám e-mail, keď vytvoríme tento návod alebo sa bude diať niečo relevantné.',
    },
    'CompanyNewsletterSubscription' => {
      label: 'Chcem dostávať novinky týkajúce sa podnikateľských subjektov',
      hint: 'Dáme vám vedieť, ak bude potrebné splniť nejakú povinnosť pre vaše podnikanie.'
    },
    'NGOSubscription' => {
      label: 'Chcem dostávať novinky týkajúce sa neziskových organizácií',
      hint: 'Upozorníme vás na prichádzajúce lehoty či povinnosti pre vaše združenie.'
    },
    'SelfEmployedSubscription' => {
      label: 'Chcem dostávať novinky pre samostatne zárobkovo činné osoby',
      hint: 'Dáme vám vedieť, keď budú mať živnostníci nové povinnosti či možnosti.'
    },
    'CarOwnerSubscription' => {
      label: 'Chcem dostávať novinky týkajúce sa majiteľov motorových vozidiel',
      hint: 'Dostávajte relevatné informácie týkajúce sa motorových vozidiel na email.'
    },
    'TaxReturnSubscription' => {
      label: 'Chcem, aby ste mi dali vedieť, keď bude dostupná aktuálna verzia aplikácie Priznanie.Digital',
      hint: 'Dáme Vám vedieť, keď bude dostupná aktuálna verzia aplikácie.'
    },
  }

  validates :journey, presence: true, if: -> { self.type == 'BlankJourneySubscription' }
  validates :email, presence: true
  validates :confirmation_token, presence: true, if: -> { user.present? }
  validates :confirmation_token, absence: true, if: -> { user.nil? }

  belongs_to :user, optional: true
  belongs_to :journey, optional: true

  def confirm
    ConfirmNotificationSubscriptionJob.perform_later(self)
  end

  def double_opt_in
    SendDoubleOptInEmailJob.perform_later(self)
  end
end

