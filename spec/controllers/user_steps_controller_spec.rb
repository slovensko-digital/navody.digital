require 'rails_helper'

RSpec.describe UserStepsController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      user_step = create(:user_step)
      user_step.step.update_attribute(:journey, user_step.user_journey.journey)

      get :show, params: { user_journey_id: user_step.user_journey.id, id: user_step.step.to_param }, session: { user_id: user_step.user_journey.user.id }
      expect(response).to have_http_status(:success)
    end
  end

end
