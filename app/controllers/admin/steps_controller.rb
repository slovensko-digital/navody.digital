class Admin::StepsController < Admin::AdminController
  before_action :set_journey
  before_action :set_step, only: [:show, :edit, :update, :destroy]

  # GET /steps
  def index
    @steps = @journey.steps.all
  end

  # GET /steps/new
  def new
    @step = @journey.steps.new
  end

  # GET /steps/1/edit
  def edit
  end

  # POST /steps
  def create
    @step = @journey.steps.new(step_params)

    if @step.save
      redirect_to admin_journey_steps_url(@step.journey), notice: 'Step was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /steps/1
  def update
    if @step.update(step_params)
      redirect_to admin_journey_steps_url(@step.journey), notice: 'Step was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /steps/1
  def destroy
    @step.destroy
    redirect_to admin_journey_steps_url(@step.journey), notice: 'Step was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_journey
    @journey = Journey.find_by!(slug: params[:journey_id])
  end

  def set_step
    @step = @journey.steps.find_by!(slug: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def step_params
    params.require(:step).permit(
        :journey_id,
        :title,
        :keywords,
        :is_waiting_step,
        :slug,
        :description,
        :position,
        :app_url,
        :type
    )
  end
end
