class NotificationSubscriptionGroup
  include ActiveModel::Model

  attr_writer :subscriptions
  attr_accessor :email
  attr_accessor :user
  attr_accessor :subscription_types
  attr_accessor :journey

  validates :subscriptions, presence: { message: 'Vyberte si aspoň jeden typ notifikácie' }
  validates :email, presence: { unless: -> { user.logged_in? }, message: 'Zadajte emailovú adresu' }
  validates :user, presence: { if: -> { user&.logged_in? } }
  validates :email, unless: -> { user.logged_in? }, if: -> { email.present? },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk" }

  def self.of(user:, **params)
    new(
      user: user,
      email: params[:email],
      subscriptions: params[:subscriptions],
      subscription_types: params[:subscription_types],
      journey: Journey.find_by(id: params[:journey_id])
    )
  end

  private_class_method :new

  def create_subscriptions
    token = SecureRandom.uuid

    subscription_types.each do |type|
      subscription = NotificationSubscription.find_or_initialize_by(type: type, email: email)

      if user_verified?
        subscription.update(user: user)
        subscription.confirm
      else
        subscription.update(confirmation_token: token, user: nil)
        subscription.double_opt_in
      end
    end
  end

  def user_verified?
    user.logged_in? && user.email == email
  end

  def subscriptions
    @subscriptions || []
  end
end
