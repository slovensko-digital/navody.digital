class NotificationSubscriptionGroup
  include ActiveModel::Model

  attr_accessor :email
  attr_accessor :user
  attr_writer :subscriptions
  attr_accessor :subscription_types
  attr_accessor :journey

  validates :subscriptions, presence: { message: 'Vyberte si aspoň jeden typ notifikácie' }
  validates :email, presence: { unless: -> { user.logged_in? }, message: 'Zadajte emailovú adresu' }
  validates :user, presence: { if: -> { user.logged_in? } }
  validates :email, unless: -> { user.logged_in? }, if: -> { email.present? }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk" }

  def self.of(attributes, user:)
    preferred_email = ActiveModel::Type::Boolean.new.cast(attributes[:prefer_email_field]) ? attributes[:email] : user.email

    new(
      email: preferred_email,
      subscriptions: attributes[:subscriptions],
      subscription_types: attributes[:subscription_types],

      journey: Journey.find_by(id: attributes[:journey_id]),

      user: (user if user.is_a?(User) && attributes[:email] == user.email) || AnonymousUser.new
    )
  end

  private_class_method :new

  def create_subscriptions
    raise unless valid?

    token = SecureRandom.uuid

    subscriptions.each do |type|
      NotificationSubscription.find_or_initialize_by(type: type, email: self.email).tap do |s|
        s.journey = journey

        if email_confirmed?
          s.update(user: user)
          s.confirm
        else
          s.update(confirmation_token: token)
          s.double_opt_in
        end
      end
    end
  end

  def email_confirmed?
    user.logged_in? && self.email == user.email
  end

  def subscriptions
    @subscriptions || []
  end

  # TODO here?
  def self.resolve_types(requested_types)
    requested_types.append('NewsletterSubscription').uniq!

    allowed = requested_types & NotificationSubscription::TYPES.keys
    forbidden = requested_types - allowed

    [allowed, forbidden]
  end
end
