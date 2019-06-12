class JourneysController < ApplicationController
  def show
    # @journey = Journey.published.find_by!(slug: params[:id])
    @journey = Journey.find_by!(slug: params[:id])
    @next_step = @journey.steps.order(:position).first

    load_newest_user_journey(current_user, @journey)

    @metadata.og.image = "journeys/#{@journey.image_name.presence || "placeholder.png" }"

  end
end
