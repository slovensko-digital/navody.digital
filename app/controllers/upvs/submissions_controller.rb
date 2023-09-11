class Upvs::SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :start

  before_action :set_metadata
  before_action :build_upvs_submission, only: :create
  before_action :load_upvs_submission, only: [:show, :submit, :finish]

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

  private

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
      :form,
      :attachments,
      :callback_url
    ).except(:authenticity_token)
  end

  def handle_error
    redirect_to action: :submission_error
  end
end
