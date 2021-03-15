class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :endpoint
  before_action :set_metadata, except: [:test, :download]
  rescue_from StandardError, with: :handle_submission_error

  def test
  end

  def endpoint
    log_out if email_mismatch?
    @subscription_types = verified_subscription_types
    @attachments = submission_params[:attachments]
    raise 'aaa'

    render :new
  end

  # TODO refactor this
  def create
    @group = NotificationSubscriptionGroup.of(notification_subscriptions_params, user: current_user)
    @submission = Submission.of(submission_params)

    if @submission.valid? && @group.valid?
      @group.create_subscriptions
      @submission.submit

      redirect_to finish_submission_path(callback_url: @submission.callback_url)
    else
      @attachments = submission_params[:attachments]

      render :new
    end
  end

  def finish
  end

  # TODO subor taha z GET parametra
  def download
    send_data Base64.decode64(params[:file]), filename: params[:name], disposition: :attachment
  end

  private

  def verified_subscription_types
    allowed_types, forbidden_types = NotificationSubscriptionGroup.resolve_types(notification_subscriptions_params[:subscription_types])
    log_error(error: ArgumentError.new, message: 'Subscription types not allowed: ', data: forbidden_types) if forbidden_types.any?

    allowed_types
  end

  def submission_params
    params.require(:submission).permit(
      :type,
      :title,
      :description,
      :user_email,
      :callback_url,
      attachments: [:filename, :content_encoded],
      target_data: {},
    ).to_h
  end

  helper_method :submission_params

  def notification_subscriptions_params
    params.require(:notification_subscriptions).permit(
      :email,
      :prefer_email_field,
      subscriptions: [],
      subscription_types: [],
    )
  end

  def email_mismatch?
    current_user.logged_in? && current_user.email != submission_params[:user_email]
  end

  def set_metadata
    params.permit!
    @metadata.og.title = params[:title] || 'Návody.Digital: Podanie'
    @metadata.og.description = params[:description] || 'Aplikácia určená pre všeobecné podania.'
  end

  def handle_submission_error(*args)
    log_error(*args)
    @attachments = submission_params[:attachments].presence

    render :error
  end
end
