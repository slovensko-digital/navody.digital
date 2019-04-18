class Admin::JourneysController < Admin::AdminController
  before_action :set_journey, only: [:show, :edit, :update, :destroy, :reposition]

  # GET /admin/journeys
  def index
    @journeys = Journey.all
  end

  # GET /admin/journeys/new
  def new
    @journey = Journey.new
  end

  # GET /admin/journeys/1/edit
  def edit
  end

  # POST /admin/journeys
  def create
    @journey = Journey.new(journey_params)

    if @journey.save
      redirect_to admin_journeys_url, notice: 'Journey was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /admin/journeys/1
  def update
    if @journey.update(journey_params)
      redirect_to admin_journeys_url, notice: 'Journey was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /admin/journeys/1
  def destroy
    return redirect_to admin_journeys_url, notice: 'You cannot destroy a published Journey' if @journey.published_status == 'PUBLISHED'
    return redirect_to admin_journeys_url, notice: 'This Journey has User Journeys, so it cannot be destroyed' if @journey.user_journeys.any?

    @journey.destroy
    redirect_to admin_journeys_url, notice: 'Journey was successfully destroyed.'
  end

  # POST /admin/journeys
  def reposition
    if @journey.reposition
      redirect_to admin_journey_steps_url(@journey), notice: 'Journeys steps were successfully repositioned.'
    else
      redirect_to admin_journey_steps_url(@journey)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_journey
    @journey = Journey.find_by!(slug: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def journey_params
    params.require(:journey).permit(
        :title,
        :image_name,
        :keywords,
        :published_status,
        :slug,
        :description,
        :position
    )
  end
end
