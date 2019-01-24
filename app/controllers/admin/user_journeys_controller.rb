class Admin::UserJourneysController < Admin::AdminController
  def index
    @user_journeys = UserJourney.all
  end

  def destroy
    @user_journey = UserJourney.find(params[:id])
    @user_journey.destroy
    redirect_to admin_user_journeys_url, notice: 'UserJourney was successfully destroyed.'
  end
end
