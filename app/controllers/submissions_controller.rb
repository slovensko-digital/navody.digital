class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :start
  before_action :set_metadata
  before_action :build_submission, only: [:start, :create]
  before_action :load_submission, only: [:show, :finish, :download_file]

  def start
    @submission.preselect_transactional_emails
  end

  def create
    if @submission.save
      redirect_to @submission
    else
      render :start, status: :unprocessable_content
    end
  end

  def show
  end

  def finish
    @submission.finish

    redirect_to @submission.callback_url
  end

  def download_file
    attachment = @submission.attachments.find { |attachment| attachment['filename'] == params[:filename] }
    if attachment
      data = Base64.decode64(attachment['body_base64']).force_encoding('UTF-8')
      send_data data, filename: attachment['filename'], disposition: :attachment
    end
  end

  def test
    render layout: false # used only in tests
  end

  private

  def submission_params
    normalize_legacy_attachments!
    params.require(:submission).permit(
      :email,
      :callback_url,
      :callback_step_path,
      :callback_step_status,
      :raw_extra,
      subscription_types: [],
      selected_subscription_types: [],
      attachments: [:filename, :body_base64],
    )
  end

  # Rack 3 parses the legacy `submission[attachments[]filename]` field
  # naming (used by older integrators) as a nested hash instead of an
  # array of hashes. Convert it to the documented shape so it survives
  # strong parameters.
  def normalize_legacy_attachments!
    submission = params[:submission]
    return unless submission.is_a?(ActionController::Parameters)

    legacy = submission.delete("attachments[")
    return unless legacy.is_a?(ActionController::Parameters)

    filename = legacy["filename]"].presence || legacy["filename"].presence
    body = legacy["body_base64]"].presence || legacy["body_base64"].presence
    return if filename.blank? && body.blank?

    submission[:attachments] = [{ "filename" => filename, "body_base64" => body }]
  end

  private

  def set_metadata
    @metadata.og.title = params[:title] || 'Návody.Digital: Podanie' # TODO
  end

  def build_submission
    @submission = current_user.build_submission(
      submission_params,
      extra: params[:submission][:extra],
      skip_subscribe: params[:skip_subscribe],
      callback_step: find_callback_step_by_path(submission_params[:callback_step_path])
    )
  end

  def load_submission
    @submission = current_user.find_submission!(params[:id] || params[:submission_id])
  end

  def find_callback_step_by_path(callback_step_path)
    route = Rails.application.routes.recognize_path(callback_step_path)
    return nil if route < { controller: 'steps', action: 'show' }

    Step.where(slug: route[:id]).joins(:journey).where(journey: { slug: route[:journey_id] }).first
  end
end
