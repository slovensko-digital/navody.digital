class JourneysController < ApplicationController
  include NotificationSubscriptionsHelper

  def show
    @journey = Journey.published.find_by!(slug: params[:id])
    @next_step = @journey.steps.order(:position).first

    load_newest_user_journey(current_user, @journey)

    @journey.description = @journey.description.gsub(/(?<=<insert_form>).*?(?=<\/insert_form>)/) {|s| render_notification_subscription_component_to_sting([s])} if @journey.description.include? '<insert_form>'

    @metadata.og.image = "journeys/#{@journey.image_name.presence || "placeholder.png" }"
  end
end
