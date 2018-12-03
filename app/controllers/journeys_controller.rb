class JourneysController < ApplicationController
  def show
    @journey = Journey.find_by!(slug: params[:slug])
    @step = @journey.steps.find_by(slug: params[:step_slug])

    if @step
      @title = @step.title
      @text = @step.description
      @starting_step = @step
    else
      @title = @journey.title
      @text = @journey.description
      @starting_step = @journey.steps.first
    end
  end
end
