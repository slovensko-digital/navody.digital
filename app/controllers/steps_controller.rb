class StepsController < ApplicationController
  def show
    @journey = Journey.find_by!(slug: params[:journey_id])
    @steps = @journey.steps
    @current_step = @steps.find_by!(slug: params[:id])
    @user_step_from_step_map = {}
  end
end
