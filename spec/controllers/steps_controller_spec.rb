require 'rails_helper'

RSpec.describe StepsController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      step = create(:step)
      get :show, params: { journey_id: step.journey.to_param, id: step.to_param }
      expect(response).to have_http_status(:success)
    end
  end

end
