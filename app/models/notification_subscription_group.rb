class NotificationSubscriptionGroup
  include ActiveModel::Model

  attr_writer :subscriptions
  attr_accessor :email
  attr_accessor :user
  attr_accessor :subscription_types
  attr_accessor :journey

  validates_presence_of :subscriptions, message: 'Vyberte si aspoň jeden typ notifikácie'
  validates_presence_of :email, unless: -> { user.logged_in? }, message: 'Zadajte emailovú adresu'
  validates :email, unless: -> { user.logged_in? }, if: -> { email.present? },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk" }

  def subscriptions
    @subscriptions || []
  end
end
