class Submission
  include ActiveModel::Model


  # TODO in progress..
  # TODO resolve and delete before merge
  require_dependency 'email_submission'

  TYPES = { email_submission: ::EmailSubmission, }

  attr_accessor :type, :title, :description, :user_email, :callback_url
  attr_writer :attachments, :target_data

  # TODO should accept other associated models
  attr_accessor :associations
  validate { associations.all?(&:valid?) }

  validates :type, :title, :description, :user_email, :attachments, presence: true
  validates :user_email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.of(attributes)
    type = TYPES[attributes[:type].to_sym]
    raise "Submission type not allowed: #{attributes[:type]}" unless type

    type_specific_attributes = attributes.delete :target_data
    attributes = attributes.merge(type_specific_attributes).to_h.compact

    type.new(attributes)
  end

  def submit
    raise NotImplementedError
  end

  def attachments
    @attachments || []
  end

  def associations
    @associations || []
  end

  def email_template
    @email_template || {}
  end

  def target_data
    @target_data || {}
  end
end
