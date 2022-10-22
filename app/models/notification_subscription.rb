class NotificationSubscription < ApplicationRecord
  self.inheritance_column = 'type2' # change
  validates :journey, presence: true, if: -> {self.type == 'BlankJourneySubscription' }

  TYPES = {
    'EpApplicationFormSubscription' => {
      sendinblue_list_name: 'EpApplicationFormSubscription',
      label: 'Chcem dostávať notifikácie k hlasovaciemu preukazu a voľbám',
      hint: 'Zašleme Vám upozornenie chvíľu pred vypršaním lehoty, aby ste sa uistili, že máte hlasovací preukaz. Taktiež Vám zašleme informačný email pred týmito a ďaľšími voľbami.',
    },
    'VoteSubscription' => {
      sendinblue_list_name: 'VoteSubscription',
      label: 'Chcem dostávať upozornenia k voľbám',
      hint: 'Zašleme Vám správu s praktickými informáciami pred týmito a ďaľšími voľbami.',
    },
    'NextVoteSubscription' => {
      sendinblue_list_name: 'NextVoteSubscription',
      label: 'Chcem dostávať notifikácie k ďalším voľbám',
      hint: 'Zašleme Vám upozornenie pred ďaľšími voľbami, aby ste sa mohli pripraviť.',
    },
    'NewsletterSubscription' => {
      sendinblue_list_name: 'NewsletterSubscription',
      label: 'Chcem odoberať pravidelné novinky Návody.Digital',
      hint: 'Ak chcete vedieť o ďalších zlepšovákoch, ktoré pripravujeme, zvoľte si túto možnosť. Neposielame žiadny spam, bude to užitočné a len raz za čas.',
    },
    'BlankJourneySubscription' => {
      label: 'Chcem odoberať informácie k tomuto návodu',
      hint: 'Zašleme Vám e-mail, keď vytvoríme tento návod alebo sa bude diať niečo relevantné.',
    },
    'CompanyNewsletterSubscription' => {
      sendinblue_list_name: 'CompanyNewsletterSubscription',
      label: 'Chcem dostávať novinky týkajúce sa podnikateľských subjektov',
      hint: 'Dáme vám vedieť, ak bude potrebné splniť nejakú povinnosť pre vaše podnikanie.'
    },
    'NGOSubscription' => {
      sendinblue_list_name: 'NGOSubscription',
      label: 'Chcem dostávať novinky týkajúce sa neziskových organizácií',
      hint: 'Upozorníme vás na prichádzajúce lehoty či povinnosti pre vaše združenie.'
    },
    'SelfEmployedSubscription' => {
      sendinblue_list_name: 'SelfEmployedSubscription',
      label: 'Chcem dostávať novinky pre samostatne zárobkovo činné osoby',
      hint: 'Dáme vám vedieť, keď budú mať živnostníci nové povinnosti či možnosti.'
    },
    'CarOwnerSubscription' => {
      sendinblue_list_name: 'CarOwnerSubscription',
      label: 'Chcem dostávať novinky týkajúce sa majiteľov motorových vozidiel',
      hint: 'Dostávajte relevatné informácie týkajúce sa motorových vozidiel na email.'
    },
    'TaxReturnSubscription' => {
      sendinblue_list_name: 'TaxReturnSubscription',
      label: 'Chcem, aby ste mi dali vedieť, keď bude dostupná aktuálna verzia aplikácie Priznanie.Digital',
      hint: 'Dáme Vám vedieť, keď bude dostupná aktuálna verzia aplikácie.'
    },
    'EmailMeSubmissionInstructionsEmail' => {
      label: 'Chcem, aby ste mi poslali inštrukcie ako odoslať toto podanie',
      hint: 'Zašleme Vám všetko potrebné na email, aby ste na nič nezabudli a mali to odložené aj na neskôr.',
      transactional: true,
      after_subscribe_message: 'email_me_after_subscribe_instructions',
      on_submission_job: EmailMeSubmissionInstructionsEmailJob
    },
    'EmailMeOrSrIdentifiersStatusEmail' => {
      label: 'Chcem, aby ste ma informovali, keď údaje budú zapísané v obchodnom registri',
      hint: 'Dáme Vám vedieť, keď chýbajúce identifikačné údaje budú zapísané v obchodnom registri.',
      on_submission_job: SaveCompanyWithMissingIdentifiersJob
    }
  }

  belongs_to :user, optional: true
  belongs_to :journey, optional: true

  def confirm
    self.confirmed_at = Time.now.utc unless self.confirmed_at
    add_email_to_list
    save
  end

  def add_email_to_list
    list_name = TYPES.dig(type, :sendinblue_list_name)
    if list_name.present?
      email_for_newsletter = user ? user.email : email
      SubscribeToNewsletterJob.perform_later(email_for_newsletter, list_name)
    end
  end
end

