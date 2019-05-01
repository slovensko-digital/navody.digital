class NotificationSubscriptionGroup
  include ActiveModel::Model

  attr_writer :subscriptions
  attr_accessor :email
  attr_accessor :user
  attr_accessor :subscription_types

  validates_presence_of :subscriptions, message: 'Vyberte si aspoň jeden typ notifikácie'
  validates_presence_of :email, unless: -> { user.logged_in? }, message: 'Zadajte emailovú adresu'
  validates :email, unless: -> { user.logged_in? }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Zadajte platnú emailovú adresu" }

  def subscriptions
    @subscriptions || []
  end
end
