class User < ApplicationRecord
  has_many :user_journeys, dependent: :destroy do
    def start!(journey)
      create!(journey: journey)
    end
  end

  has_many :user_steps, through: :user_journeys
  has_many :user_tasks, through: :user_steps
  has_many :notification_subscriptions
  has_many :submissions
  has_many :upvs_submissions

  def logged_in?
    true
  end

  def build_submission(params, extra:, skip_subscribe:, callback_step:)
    submission = submissions.build(params)
    submission.email = email if submission.email.blank?
    submission.extra = params[:raw_extra] ? JSON.parse(params[:raw_extra]) : extra
    submission.skip_subscribe = skip_subscribe
    submission.current_user = self
    submission.callback_step = callback_step
    submission
  end

  def find_submission!(uuid)
    submission = submissions.find_by!(uuid: uuid)
    submission.current_user = self
    submission
  end

  def build_upvs_submission(params, callback_step:)
    upvs_submission = upvs_submissions.build(params.except(:form_blob_id))
    upvs_submission.form.attach(ActiveStorage::Blob.find_by(id: params[:form_blob_id]))
    upvs_submission.current_user = self
    upvs_submission.callback_step = callback_step
    upvs_submission
  end

  def find_upvs_submission!(uuid)
    upvs_submission = upvs_submissions.find_by!(uuid: uuid)
    upvs_submission.current_user = self
    upvs_submission
  end

  def update_step_status(step, status)
    find_or_create_user_journey(step.journey).user_steps.find_or_initialize_by(step: step).update(status: status)
  end

  private

  def find_or_create_user_journey(journey)
    UserJourney.order(id: :desc).find_by(user: self, journey: journey) || user_journeys.create!(journey: journey)
  end
end
