class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :submission
  before_action :log_out, if: :email_mismatch
  before_action :set_, if: :email_mismatch

  # TODO prerobit na resources style [POST na submissions#create, nie na submit]
  # TODO extendnut notification subscription group a zjednotit to pod ActiveModel Submission, pripadne zjednotit, nech cele navody riesia notification subscriptions cez jedno miesto (pouzit Sendinblue?)
  # TODO parametrizovat nadpis, nazov suboru a dalsie veci


  def submission

    # TODO toto parametrizovat a pripadne pouzit v nazve stahovaneho suboru atd.
    @submission_title = 'Odklad daňového priznania'
    @metadata.og.title = "Návody.Digital: #{@submission_title}"

    #TODO warning ak posiela iny typ subscription ako povolene?
    @subscription_types = NotificationSubscription::TYPES.keys & submission_params[:notification_subscriptions] << 'NewsletterSubscription'
    @attachment = Base64.decode64(submission_params[:file_attachment])
    @email = submission_params[:email]

    render 'submissions/submission'
  end

  # TODO cely subor v GET parametri nechceme
  def download
    send_data params[:file], filename: 'odklad-danoveho-priznania.xml'
  end

  def submit
    submission_args = internal_params
    @group = NotificationSubscriptionGroup.new
    @group.email = submission_args[:notification_subscription_group][:email]
    @group.subscriptions = submission_args[:notification_subscription_group][:subscriptions]
    @group.user = current_user
    @group.journey = nil # TODO

    respond_to do |format|
      format.js { render :new } if @group.invalid?

      create_subscriptions(submission_args)
      SendEmailFromTemplateJob.perform_later(submission_args)
      format.html { redirect_to finish_submission_path }
      format.js
    end
  end

  private

  def submission_params
    params.permit(:email, :email_subject, :email_body, :file_attachment, notification_subscriptions: [])
  end

  # TODO delete if equal to previous helper
  def internal_params
    params.permit(:email, :email_subject, :email_body, :file_attachment, notification_subscriptions: [])
  end

  def email_mismatch
    current_user.is_a?(User) && current_user.email != submission_params[:email]
  end

  def provide_as_file(input)
    Tempfile.open do |file|
      file.write(input.force_encoding("UTF-8"))
      file.rewind
      yield file
      file.unlink
    end
  end


  # TODO analogous with AnonymousUser[User].create. consider refactor as that methods have many responsibilities
  def create_subscriptions(params)
    params[:subscriptions].map do |type|
      user = current_user.is_a? User ? current_user : nil
      subscription = NotificationSubscription.find_or_initialize_by(type: type, email: params[:email], user: user)
      subscription.confirmation_sent_at = Time.now.utc unless user
      subscription.save!
      subscription
    end
  end
end
