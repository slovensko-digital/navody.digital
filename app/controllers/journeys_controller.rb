class JourneysController < ApplicationController
  def show
    @journey = Journey.find_by!(slug: params[:id])
    @step = @journey.steps.find_by(slug: params[:step_slug])

    if @step
      @text = @step.description
    else
      @text = @journey.description
    end
  end
end
