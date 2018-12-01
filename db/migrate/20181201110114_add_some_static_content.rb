class AddSomeStaticContent < ActiveRecord::Migration[5.2]
  def change
    Page.create!(
      title: 'Kontaktné informácie',
      content: 'Tu raz urcite budu nejake informacie o tom, ako kontaktovat ludi, ktori su za touto strankou',
      slug: 'contact-info',
      is_faq: false
    )

    Page.create!(
      title: 'Čo je vlastne to EID, o ktorom sa tu všade píše?',
      content: 'Občiansky preukaz s čipom, na ktorom je aktivovaný BOK, ZEP PIN a ZEP PUK',
      slug: 'co-je-to-eid',
      is_faq: true
    )
  end
end
