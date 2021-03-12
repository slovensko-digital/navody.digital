class SubmissionsController < ApplicationController
  include Caching

  skip_before_action :verify_authenticity_token, only: :endpoint
  before_action :set_metadata, except: [:test, :download]
  before_action :load_attachments, except: [:endpoint, :test]

  wrap_parameters :submission, except: :test
  # before_action :log_out, unless: :current_user_email_matches?, only: :endpoint
  # rescue_from StandardError, with: :handle_submission_error

  def test
  end

  def endpoint
    log_out if email_mismatch?
    store_sensitive_data

    redirect_to new_submission_path(submission: submission_params, notification_subscription_group: notification_subscription_params)
  end

  def new
    set_subscription_types
  end

  def create
    @submission = Submission.of(submission_params.merge(user: current_user, attachments: load_attachments))
    # @group = NotificationSubscriptionGroup.of(notification_subscription_params)

    respond_to do |format|
      format.js { render :new } and return unless @group.valid?

      if @submission.valid? && @group.valid?
        # @group.create_subscriptions
        @submission.submit

        redirect_to finish_submission_path(submission_params[:callback])
      else
        render :new
      end
    end
  end

  def finish
  end

  def download
    attachment = attachments[Integer(params[:id])]

    send_data Base64.decode64(attachment[:encoded_file]), filename: attachment[:filename], disposition: :attachment
  end

  private

  def set_subscription_types
    requested_types = ['NewsletterSubscription', *notification_subscription_params[:subscription_types]].uniq
    allowed_types = requested_types & NotificationSubscription::TYPES.keys
    @subscription_types = allowed_types

    forbidden_types = requested_types - allowed_types
    log_error(ArgumentError.new, 'Subscription types not allowed', data: forbidden_types) if forbidden_types.any?
  end

  def store_sensitive_data
    data = params.require(:submission).permit!.slice(:attachments).to_h

    save_to_cache(data)
  end

  def load_attachments
    @attachments ||= load_from_cache(:attachments)
  end

  helper_method :load_attachments

  def submission_params
    params.require(:submission).permit(
      :type,
      :title,
      :description,
      target_data: {},
      callback: [:url, options: {}],
    )
  end

  helper_method :submission_params

  # TODO maybe useless
  def notification_subscription_params
    filtered = params.require(:notification_subscription_group)

    prefer_input = ActiveModel::Type::Boolean.new.cast(filtered.delete(:prefer_email_input))
    logged = filtered.delete :logged_user_email
    input = filtered.delete :email_input

    filtered[:email] = (current_user.logged_in? && !prefer_input) ? logged : input

    filtered.permit(
      :email,
      subscriptions: [],
      subscription_types: [],
    )
  end

  def email_mismatch?
    current_user.logged_in? && current_user.email == submission_params[:email]
  end

  def set_metadata
    @metadata.og.title = submission_params[:title] || 'Návody.Digital: Podanie'
    @metadata.og.description = submission_params[:description] || 'Aplikácia určená pre všeobecné podania.'
  end

  # def handle_submission_error(error)
  #   log_error
  #
  #   render :error
  # end
end
