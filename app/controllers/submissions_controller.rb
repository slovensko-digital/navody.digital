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
      redirect_to submission_path(@submission)
    else
      render :start, status: :unprocessable_entity
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
    params.require(:submission).permit(
      :email,
      :callback_url,
      :callback_step_path,
      :callback_step_status,
      :raw_extra,
      subscription_types: [],
      selected_subscription_types: [],
      attachments: [:filename, :body_base64],
      extra: {},
    )
  end

  private

  def set_metadata
    @metadata.og.title = params[:title] || 'Návody.Digital: Podanie' # TODO
  end

  def build_submission
    @submission = current_user.build_submission(
      submission_params,
      extra: params[:submission][:extra],
      skip_subscribe: params[:skip_subscribe]
    )
  end

  def load_submission
    @submission = current_user.find_submission!(params[:id] || params[:submission_id])
    @submission.current_user = current_user
  end
end
