class Admin::JourneyLegalDefinitionsController < Admin::AdminController
  before_action :set_journey
  before_action :set_journey_legal_definition, only: [:edit, :update, :destroy]

  def index
    @journey_legal_definitions = @journey.journey_legal_definitions.all
  end

  def new
    @journey_legal_definition = @journey.journey_legal_definitions.new
  end

  def edit
  end

  def create
    @journey_legal_definition = @journey.journey_legal_definitions.new(journey_legal_definition_params)

    law_identifier = Legal::SlovLexLink.new(@journey_legal_definition.link).current_date_version()
    law = Law.find_or_create_by!(identifier: law_identifier)
    @journey_legal_definition.law = law

    if @journey_legal_definition.save
      redirect_to admin_journey_journey_legal_definitions_url(@journey_legal_definition.journey), notice: 'Journey legal definition was successfully created.'
    else
      render :new
    end
  end

  def update
    if @journey_legal_definition.update(journey_legal_definition_params)
      redirect_to admin_journey_journey_legal_definitions_url(@journey_legal_definition.journey), notice: 'Journey legal definition was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @journey_legal_definition.destroy
    redirect_to admin_journey_journey_legal_definitions_url(@journey_legal_definition.journey), notice: 'Journey legal definition was successfully destroyed.'
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_journey
    @journey = Journey.find_by!(slug: params[:journey_id])
  end

  def set_journey_legal_definition
    @journey_legal_definition = @journey.journey_legal_definitions.find_by!(id: params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def journey_legal_definition_params
    params.require(:journey_legal_definition).permit(
        :journey_id,
        :link,
        :note
    )
  end
end
