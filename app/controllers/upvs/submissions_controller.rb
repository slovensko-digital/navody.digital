class Upvs::SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :start

  before_action :set_metadata
  before_action :build_upvs_submission, only: :create
  before_action :load_upvs_submission, only: [:show, :submit, :finish, :signing_data, :update_blob_after_signature]
  before_action :load_blob, only: [:signing_data, :update_blob_after_signature]

  rescue_from Upvs::Submission::SkApiError, :with => :handle_error

  def create
    if @upvs_submission.save!
      redirect_to @upvs_submission
    else
      render :start, status: :unprocessable_entity
    end
  end

  def show
    @token = eid_token
    session[:submission_callback] = request.url
  end

  def login_callback
    session[:eid_encoded_token] = params[:token]

    redirect_to session[:submission_callback]
  end

  def switch_account_callback
    session.delete(:eid_encoded_token)

    redirect_to session[:submission_callback]
  end

  def submit
    return switch_account_callback unless eid_token&.valid? # If token expires meanwhile

    if @upvs_submission.submit(eid_token)
      if @upvs_submission.callback_url.present?
        redirect_to @upvs_submission.callback_url
      else
        redirect_to action: :finish
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def finish
  end

  def submission_error
  end

  def signing_data
    response = {
      file_name: @blob.filename,
      mime_type: @blob.content_type,
      content: Base64.strict_encode64(@blob.download)
    }

    # This mime type is set in `UpvsSubmissions::Forms::GeneralAgenda#create_form_attachment`
    if @blob.content_type == 'application/x-eform-xml'
      form_template = Upvs::FormTemplateRelatedDocument.find_by!(message_type: 'App.GeneralAgenda')

      response.merge!({
        identifier: form_template.identifier,
        container_xmlns: 'http://data.gov.sk/def/container/xmldatacontainer+xml/1.1',
        schema: Base64.strict_encode64(form_template.xsd_schema),
        transformation: Base64.strict_encode64(form_template.xslt_transformation)
      })
    end

    render json: response
  end

  def update_blob_after_signature
    render_partial = params[:render_partial].in?(['signed_badge', 'blob_row']) ? params[:render_partial] : 'signed_badge'
    new_blob =  ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(params[:content]),
      filename: params[:name],
      content_type: params[:mimetype],
      metadata: { signed: true, signed_required: @blob.metadata[:signed_required] }.compact
    )

    ActiveStorage::Attachment
      .where(blob_id: @blob.id, record: @upvs_submission)
      .update_all(blob_id: new_blob.id)

    render json: { success: true, old_blob_id: @blob.id, badge: render_to_string(partial: "upvs/submissions/#{render_partial}") }
  rescue StandardError, ScriptError => e
    render json: { success: false, error: "Nastala chyba pri podpisovaní. [#{e.class}]: #{e.message}" }
  end

  private

  def load_blob
    @blob = ActiveStorage::Blob.find_signed!(params[:signed_blob_id]) # This is only 'hashed blob ID', not signed blob object nor file
  end

  def load_upvs_submission
    @upvs_submission = current_user.find_upvs_submission!(params[:id] || params[:submission_id])
  end

  def find_callback_step_by_path(callback_step_path)
    route = Rails.application.routes.recognize_path(callback_step_path)
    return nil if route < { controller: 'steps', action: 'show' }

    Step.where(slug: route[:id]).joins(:journey).where(journey: { slug: route[:journey_id] }).first
  end

  def set_metadata
    @metadata.og.title = params[:title] || 'Návody.Digital: Podanie' # TODO
  end

  def build_upvs_submission
    @upvs_submission = current_user.build_upvs_submission(
      submission_params,
      callback_step: find_callback_step_by_path(submission_params[:callback_step_path])
    )
  end

  def submission_params
    params.require(:upvs_submission).permit(
      :authenticity_token,
      :title,
      :posp_id,
      :posp_version,
      :message_type,
      :recipient_uri,
      :sender_business_reference,
      :recipient_business_reference,
      :message_subject,
      :form_blob_id,
      :attachments,
      :callback_url
    ).except(:authenticity_token)
  end

  def handle_error
    redirect_to action: :submission_error
  end
end
