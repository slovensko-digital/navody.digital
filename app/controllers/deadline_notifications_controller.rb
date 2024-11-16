class DeadlineNotificationsController < ApplicationController
  before_action :set_journey_and_step
  def subscribe_to_deadline_notification
    notification_date = params[:notification_date] ? Date.parse(params[:notification_date]) : nil
    notification_date ||= Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    @user_journey = UserJourney.order(id: :desc).find_by(user: current_user, journey: @journey)
    @user_step = @user_journey.user_steps.find_by(step: @current_step)

    @user_step.update(to_be_notified_at: notification_date)
    respond_to do |format|
      format.html do
        redirect_to [@journey, @current_step]
      end
      format.js do
        render 'deadline_notifications_updated'
      end
    end

  rescue Date::Error => e
    respond_to do |format|
      format.html do
        redirect_to [@journey, @current_step]
      end
      format.js do
        render 'deadline_notifications_update_error'
      end
    end
  end

  def unsubscribe_deadline_notification
    @user_journey = UserJourney.order(id: :desc).find_by(user: current_user, journey: @journey)
    @user_step = @user_journey.user_steps.find_by(step: @current_step)

    @user_step.update(to_be_notified_at: nil)

    respond_to do |format|
      format.html do
        redirect_to [@journey, @current_step]
      end
      format.js do
        render 'deadline_notifications_updated'
      end
    end

  end

  private

  def set_journey_and_step
    @journey = Journey.published.find_by!(slug: params[:journey_id])
    @current_step = @journey.steps.find_by!(slug: params[:id])
  end
end
