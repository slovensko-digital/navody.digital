class Upvs::SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:new]
  before_action :load_upvs_submission, only: [:new, :sign, :create, :submit, :continue]

  def new
  end

  def create
    unless @upvs_submission.valid?
      render :new, status: :unprocessable_entity
    end
  end

  def finish
  end

  def login_callback
    session[:eid_token] = params[:token]
    @token = params[:token]

    render layout: false # TODO show something nice
  end

  def switch_account_callback
    session.delete(:eid_token)
    @token = nil
    render action: :login_callback, layout: false # TODO run logout/login flow
  end

  def submit
    if @upvs_submission.save
      if @upvs_submission.callback_url.present?
        render action: :continue
      else
        redirect_to action: :finish
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def load_upvs_submission
    @upvs_submission = Upvs::Submission.new(application_params)
  end

  def application_params
    params.require(:upvs_submission).permit(
      :posp_id,
      :posp_version,
      :message_type,
      :recipient_uri,
      :sender_business_reference,
      :recipient_business_reference,
      :message_subject,
      :form,
      :attachments
    ) if params.key?(:upvs_submission)
  end
end
