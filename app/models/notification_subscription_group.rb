class NotificationSubscriptionGroup
  include ActiveModel::Model

  attr_writer :subscriptions
  attr_accessor :email
  attr_accessor :user
  attr_accessor :subscription_types

  validates_presence_of :subscriptions, message: 'Vyberte si aspoň jeden typ notifikácie'
  validates_presence_of :email, unless: -> { user.logged_in? }, message: 'Zadajte emailovú adresu'

  def subscriptions
    @subscriptions || []
  end
end
