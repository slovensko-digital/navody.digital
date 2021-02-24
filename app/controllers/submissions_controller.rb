class SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :submission
  #TODO
  before_action :log_out, unless: :current_user_email_matches?

  # TODO prerobit na resources style [POST na submissions#create, nie na submit]
  # TODO extendnut notification subscription group a zjednotit to pod ActiveModel Submission, pripadne zjednotit, nech cele navody riesia notification subscriptions cez jedno miesto (pouzit Sendinblue?)
  # TODO parametrizovat nadpis a dalsie veci


  def submission
    # TODO toto parametrizovat a pripadne pouzit v nazve stahovaneho suboru atd.
    @submission_title = 'Odklad daňového priznania'
    @metadata.og.title = "Návody.Digital: #{@submission_title}"

    resolve_subscription_types
    parse_attachments

    render 'submissions/submission' #, alert:
  end

  def create
    submission_args = submission_params
    @group = NotificationSubscriptionGroup.new
    @group.email = submission_args[:user_email]
    @group.subscriptions = submission_args[:notification_subscription_types]
    @group.user = current_user

    respond_to do |format|
      format.js { render :new } if @group.invalid?

      create_subscriptions(submission_args)
      SendEmailFromTemplateJob.perform_later(submission_args)

      format.html { redirect_to finish_submission_path }
      format.js
    end
  end

  # TODO first prec ked pridame podporu viacerych priloh
  def download
    attachments_temp = get_attachments.first
    send_data attachments_temp[:content], filename: attachments_temp[:filename], type: attachments_temp[:content_type]
  end

  private

  def resolve_subscription_types
    requested = ['NewsletterSubscription', *submission_params[:notification_subscription_types]].uniq
    permitted = @subscription_types = requested & NotificationSubscription::TYPES.keys
    forbidden = requested - permitted

    Rollbar.error(ArgumentError, forbidden) if forbidden.size > 0
  end

  def parse_attachments
    attachments = submission_params.fetch(:attachments).map do |a|
      Hash[
        filename: a[:filename],
        content: a[:uploaded_file].read,
        content_type: a[:uploaded_file].content_type
      ]
    end

    Rails.cache.write([get_or_init_uuid, :attachments], attachments, expires_in: 48.hours)
  end

  def get_attachments
    Rollbar.error(RuntimeError, 'UUID not present in session') and return unless uuid

    @attachments ||= Rails.cache.read([uuid, :attachments])
  end

  def submission_params
    params.require(:submission).permit(
      :type,
      :user_email,
      :recipient_name,
      attachments: [:filename, :uploaded_file],
      email_template: [:id, params: {}],
      notification_subscription_types: [],
    )
  end

  def current_user_email_matches?
    current_user.logged_in? && current_user.email == submission_params[:email]
  end

  helper_method :current_user_email_matches?

  # TODO analogous with AnonymousUser[User].create. consider refactor as that methods have many responsibilities
  def create_subscriptions(params)
    puts '-------------------'
    puts params
    puts '====================='
    params[:subscriptions].map do |type|
      user = (current_user if current_user.logged_in?) || nil
      subscription = NotificationSubscription.find_or_initialize_by(type: type, email: params[:email], user: user)
      subscription.confirmation_sent_at = Time.now.utc unless user
      subscription.save!
      subscription
    end
  end
end

# # EXAMPLE (testy a vizualizacia docasne)
# SUBMISSION_TYPES = ['EmailMeSubmission']
#
#
# {
#   submission: {
#     type: 'EmailMeSubmission',
#     user_email: 'test@test.com', # email z priznania, check equality s current_user na navodoch
#     recipient_name: 'Jozef Testovaci',
#     attachments: [
#       {
#         filename: 'odklad-danoveho-priznania.xml',
#         content: '<file_content>', # html select file -> submit
#       },
#     ],
#     email_template: {
#       id: 166,
#       params: {
#         first_name: 'Jozef',
#         last_name: 'Testovaci',
#         deadline: '30.6.2021',
#         newsletter: true,
#       },
#     },
#     notification_subscriptions_types: ['TaxReturnSubscription'], # NewsletterSubscription je default
#   }
# }