class Submission
  include ActiveModel::Model


  # TODO in progress..
  # TODO resolve and delete before merge
  require_dependency 'email_submission'

  TYPES = { email_submission: ::EmailSubmission }

  attr_accessor :type, :title, :description, :name, :email
  attr_writer :attachments, :callback, :target_data

  attr_accessor :subscription_group

  validates :type, :title, :description, :name, :email, :callback, :attachments, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.of(attributes)
    target_class = TYPES[attributes[:type].to_sym]

    raise "Submission type not allowed: #{attributes[:type]}" unless target_class

    flat_attributes = attributes.except(:target_data).merge(attributes[:target_data]).to_h.compact

    target_class.new(target_attributes)
  end

  def submit
    raise NotImplementedError
  end

  def attachments
    @attachments || []
  end

  def callback
    @callback || {}
  end

  def email_template
    @email_template || {}
  end

  def target_data
    @target_data || {}
  end
end
