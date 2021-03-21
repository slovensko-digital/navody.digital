class Submission < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :callback_step, optional: true, class_name: 'Step'
  attr_accessor :subscription_types, :raw_extra, :skip_subscribe, :current_user, :callback_step_path

  before_create { self.uuid = SecureRandom.uuid } # TODO ensure unique in loop
  before_create { self.selected_subscription_types = [] if skip_subscribe }
  after_create :subscribe, unless: :skip_subscribe

  validates_presence_of :email, message: 'Zadajte emailovú adresu', unless: :skip_subscribe
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Zadajte emailovú adresu v platnom tvare, napríklad jan.novak@firma.sk" }, unless: :skip_subscribe
  validates :selected_subscription_types, presence: { message: 'Vyberte si aspoň jednu možnosť' }, unless: :skip_subscribe

  scope :expired, -> { where('created_at < ?', 20.minutes.ago) }

  def subscribe
    selected_subscription_objects.filter_map { |s| s[:on_submission_job] }.each { |job| job.perform_later(self) }

    NotificationSubscriptionGroup.new(
      selected_subscription_types: selected_subscription_types,
      email: email,
      user: current_user,
    ).save
  end

  def finish
    if current_user.logged_in? && callback_step && callback_step_status
      current_user.update_step_status(callback_step, callback_step_status)
    end
  end

  def selected_subscription_objects
    selected_subscription_types.filter_map { |type| NotificationSubscription::TYPES[type] }
  end

  def preselect_transactional_emails
    self.selected_subscription_types = subscription_types.filter_map { |type| type if NotificationSubscription::TYPES[type][:transactional] }
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
