class MakeNavigationLinksLanguageConsistent < ActiveRecord::Migration[6.0]
  def change
    Page.find_by(slug: 'contact-info')&.update!(slug: 'kontakt')
    Page.find_by(slug: 'disclaimer')&.update!(slug: 'podmienky-pouzivania')
  end
end
