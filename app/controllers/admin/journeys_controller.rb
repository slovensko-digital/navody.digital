class Admin::JourneysController < Admin::AdminController
  def index
    @journeys = Journey.all
  end

  def show
    journey_id = params.require(:id)

    @journey = Journey.find(journey_id)
  end
end
