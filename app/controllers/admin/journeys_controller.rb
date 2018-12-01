class Admin::JourneysController < Admin::AdminController
  def index
    @journeys = Journey.all
  end
end
