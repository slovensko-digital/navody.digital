class Admin::JourneysController < Admin::AdminController
  before_action :set_journey, only: [:show, :edit, :update, :destroy, :reposition]

  # GET /admin/journeys
  def index
    query = <<-SQL
WITH active_law_versions AS (
    SELECT * FROM law_versions lv WHERE lv.valid_from <= current_date AND (lv.valid_to > current_date OR lv.valid_to IS NULL)
) SELECT j.*, alerting_journeys.id IS NULL as check_valid FROM journeys j
LEFT JOIN (
    SELECT DISTINCT jo.id
    FROM journeys jo
    JOIN journey_legal_definitions jld on jo.id = jld.journey_id
    JOIN laws l on jld.law_id = l.id
    JOIN active_law_versions alv on alv.law_id = l.id
    WHERE alv.valid_from > jo.last_checked_on
) alerting_journeys ON j.id = alerting_journeys.id
    SQL

    query << " WHERE published_status = '#{params[:status]}'" unless params[:status].blank?

    @journeys = Journey.find_by_sql(query)
  end

  # GET /admin/journeys/new
  def new
    @journey = Journey.new
    @journey.categorization = Categorization.new(categorizable: @journey)
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

  # POST /admin/journeys/1/reposition
  def reposition
    @journey.reposition
    redirect_to admin_journey_steps_path(@journey), notice: 'Journeys steps were successfully repositioned.'
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
        :custom_title,
        :image_name,
        :keywords,
        :short_description,
        :published_status,
        :slug,
        :description,
        :position,
        :last_checked_on,
        categorization_attributes: [:id, category_ids: []]
    )
  end
end
