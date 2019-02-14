require 'rails_helper'

RSpec.describe UserStepsController, type: :controller do
  let!(:journey) { create(:journey) }
  let!(:step) { create(:step, journey: journey) }
  let!(:user_journey) { create(:user_journey, journey: journey) }
  let!(:user_step) { create(:user_step, step: step, user_journey: user_journey) }

  describe "GET #show" do
    it "returns http success" do
      # user_step = create(:user_step)
      user_step.step.update_attribute(:journey, user_step.user_journey.journey)

      get :show, params: { user_journey_id: user_step.user_journey.id, id: user_step.step.to_param }, session: { user_id: user_step.user_journey.user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #set_status' do
    subject do
      post :set_status,
      params: { "user_journey_id"=>"#{user_step.user_journey.id}", "id"=>"#{user_step.step.slug}", "status"=>"waiting" },
      session: { user_id: user_step.user_journey.user.id }
    end


    it 'Changes user step status' do
      subject

      expect(user_step.reload.status).to eq 'waiting'
    end

    # it 'Redirects to user step detail' do
    #   subject
    #
    #   expect(response).to redirect_to(
    #     user_journey_step_path(user_journey_id: user_journey.id, id: user_step.step.slug)
    #   )
    # end
  end

end
