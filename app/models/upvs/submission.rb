# == Schema Information
#
# Table name: upvs.submissions
#
#  id                                :integer          not null, primary key
#  uuid                              :uuid             not null
#  user_id                           :integer          not null
#  anonymous_user_uuid               :uuid             not null
#  title                             :string           not null
#  posp_id                           :string           not null
#  posp_version                      :string           not null
#  message_type                      :string           not null
#  message_subject                   :string           not null
#  recipient_uri                     :string           not null
#  sender_business_reference         :string
#  recipient_business_reference      :string
#  form                              :text             not null
#  callback_url                      :string
#  callback_step_id                  :string
#  callback_step_status              :string
#  expires_at                        :datetime
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#

class Upvs::Submission  < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :callback_step, optional: true, class_name: 'Step'
  attr_accessor :subscription_types, :raw_extra, :skip_subscribe, :current_user, :callback_step_path

  before_create { self.uuid = SecureRandom.uuid } # TODO ensure unique in loop
  before_create { set_new_expiration_time }

  validates_presence_of :posp_id, :posp_version, :message_type, :recipient_uri, :message_subject, :form, on: :create
  validate :recipient_uri_allowed?, if: -> { Rails.env.production? }, on: :create
  validate :egov_application_allowed?, if: -> { Rails.env.production? }, on: :create
  validate :valid_xml_form?, on: :create

  scope :expired, -> { where('expires_at < ?', Time.zone.now) }

  self.table_name = "upvs.submissions"

  def form
    ActiveStorage::Blob.find_by(filename: "upvs-submission-#{id}.xml") || ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(attributes['form']),
      filename: "upvs-submission-#{id}.xml",
      content_type: 'application/x-eform-xml'
    )
  end

  def recipient_name
    return recipient_uri if Rails.env.development?

    @recipient_name ||= Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).pluck(:name).first
  end

  def message_id
    @message_id ||= SecureRandom.uuid
  end

  def correlation_id
    SecureRandom.uuid
  end

  def form_visualisation
    xslt_transformation
  end

  def finish
    if current_user.logged_in? && callback_step && callback_step_status
      current_user.update_step_status(callback_step, callback_step_status)
    end
  end

  def to_param
    uuid
  end

  def submit(eid_token, client: Faraday, url: "#{ENV.fetch('SLOVENSKO_SK_API_URL')}/api/sktalk/receive_and_save_to_outbox?token=#{eid_token&.api_token}")
    return false unless valid?

    response = submit_to_sk_api(client, url, eid_token)

    if successful_sk_api_submission?(response)
      update(expires_at: Time.zone.now)
      return true
    else
      raise Upvs::Submission::SkApiError.new
    end
  end

  private

  def validate
    false unless valid?
  end

  def submit_to_sk_api(client, url, eid_token)
    begin
      headers =  { "Content-Type": "application/json" }
      data =  { message: UpvsSubmissions::SktalkMessageBuilder.new.build_sktalk_message(self, eid_token) }.to_json

      client.post(url, data, headers)
    rescue Exception
      raise Upvs::Submission::SkApiError.new
    end
  end

  def successful_sk_api_submission?(response)
    json_body = JSON.parse(response.body)

    return true if (response.status == 200 && json_body["receive_result"] == 0 && json_body["save_to_outbox_result"] == 0)
    false
  end

  def set_new_expiration_time
    self.expires_at = Time.zone.now + 20.minutes
  end

  def egov_application_allowed?
    unless Upvs::EgovApplicationAllowRule.exists?(recipient_uri: recipient_uri, posp_id: posp_id, posp_version: posp_version, message_type: message_type)
      errors.add(:disallowed_form_type, "Prijímateľ nie je oprávnený prijať daný typ podania")
    end
  end

  def xslt_transformation
    unless (form_related_document = Upvs::FormTemplateRelatedDocument.where(posp_id: posp_id, posp_version: posp_version, message_type: message_type).first)
      raise MissingFormTemplateError.new
    end

    xslt_template = Nokogiri::XSLT(form_related_document.xslt_transformation)

    xslt_template.transform(Nokogiri::XML(form.download)).to_s.gsub('"', '\'')
  end

  def recipient_uri_allowed?
    unless Datahub::Upvs::PublicAuthorityEdesk.where(uri: recipient_uri).exists?
      errors.add(:recipient_name, "Príjimateľ je neznámy")
    end
  end

  def valid_xml_form?
    unless Nokogiri::XML(form).errors.empty?
      errors.add(:form, "Nevalidný XML formulár")
    end
  end

  class SkApiError < StandardError
  end

  class MissingFormTemplateError < StandardError
  end
end
