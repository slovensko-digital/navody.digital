class NotificationSubscriptionGroup
  include ActiveModel::Model

  attr_writer :selected_subscription_types
  attr_accessor :email
  attr_accessor :user
  attr_accessor :subscription_types
  attr_accessor :journey

  validates_presence_of :selected_subscription_types, message: 'Vyberte si aspoň jeden typ notifikácie'
  validates_presence_of :email, unless: -> { user.logged_in? }, message: 'Zadajte emailovú adresu'
  validates :email, unless: -> { user.logged_in? }, if: -> { email.present? },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk" }

  def selected_subscription_types
    @selected_subscription_types || []
  end

  def save
    if email.present?
      subscribe_with_confirmation
    else
      subscribe_without_confirmation
    end
  end

  private

  def subscribe_with_confirmation
    token = SecureRandom.uuid
    selected_subscription_types.each do |type|
      subscription = NotificationSubscription.find_or_initialize_by(type: type, email: email)
      subscription.confirmation_token = token
      subscription.confirmation_sent_at = Time.now.utc
      subscription.journey = journey
      subscription.save!
    end

    NotificationSubscriptionMailer.with(email: email, token: token).confirmation_email.deliver_later
  end

  def subscribe_without_confirmation
    selected_subscription_types.each do |type|
      subscription = NotificationSubscription.find_or_initialize_by(type: type, email: user.email)
      subscription.journey = journey
      subscription.confirm
    end
  end
end
