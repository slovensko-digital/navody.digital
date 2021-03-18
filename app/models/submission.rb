class Submission < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :callback_step, class_name: 'Step', optional: true
  attr_accessor :subscription_types, :raw_extra

  before_create { self.uuid = SecureRandom.uuid } # TODO ensure unique in loop
  after_create :subscribe

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Zadajte emailovú adresu' }, unless: -> { user && user.logged_in? }, on: :subscribe
  validates :selected_subscription_types, presence: { message: 'Vyberte si aspoň jednu možnosť' }, on: :subscribe

  scope :expired, -> { where('created_at < ?', 20.minutes.ago) }

  def subscribe
    selected_subscription_objects.filter_map { |s| s[:on_submission_job] }.each { |job| job.perform_later(self) }

    NotificationSubscriptionGroup.new(
      selected_subscription_types: selected_subscription_types,
      email: email,
      user: user,
    ).save
  end

  def finish
    # TODO step status changes
  end

  def selected_subscription_objects
    selected_subscription_types.filter_map { |type| NotificationSubscription::TYPES[type] }
  end

  def to_param
    uuid
  end

  def raw_extra
    extra.to_json
  end

  def after_subscribe_messages
    selected_subscription_objects.filter_map { |s| s[:after_subscribe_message] }
  end

  def attachments
    read_attribute(:attachments) || {}
  end

  def user_email
    email.presence || user.email
  end
end
