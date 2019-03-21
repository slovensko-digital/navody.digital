require 'rails_helper'

RSpec.describe UserStepsController, type: :controller do
  let!(:journey) { create(:journey) }
  let!(:step) { create(:step, journey: journey) }
  let!(:user_journey) { create(:user_journey, journey: journey) }
  let!(:user_step) { create(:user_step, step: step, user_journey: user_journey) }

  describe "GET #show" do

    subject do
      get :show,
          params: { user_journey_id: requested_user_journey_id, id: step.to_param },
          session: session
    end

    context 'Requesting existing user journey' do
      let(:requested_user_journey_id) { user_journey.id }

      context 'With signed in user' do
        context 'When user_journey_id belongs to current user' do
          let(:session) do
            { user_id: user_journey.user.id }
          end

          it "returns http success" do
            subject
            expect(response).to have_http_status(:success)
          end
        end

        context 'When user_journey_id belongs to different user' do
          let!(:signed_in_user) { create(:user) }
          let(:session) do
            { user_id: signed_in_user.id }
          end

          it 'Redirects to related journey' do
            expect(subject).to redirect_to journey_url(journey)
          end
        end
      end

      context 'When user is signed out' do
        let(:session) do
          {}
        end

        it 'Redirects to related journey' do
          expect(subject).to redirect_to journey_url(journey)
        end
      end
    end

    context 'Requesting non existing user journey' do
      let(:requested_user_journey_id) { user_journey.id + 1 }

      it 'Redirects to root' do
        expect(subject).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do
    subject do
      patch :update,
      params: { "user_journey_id"=>"#{user_step.user_journey.id}", "id"=>"#{user_step.step.slug}", "status"=>"waiting" },
      session: { user_id: user_step.user_journey.user.id }
    end


    it 'Changes user step status' do
      subject

      expect(user_step.reload.status).to eq 'waiting'
    end

    it 'Redirects to user step detail' do
      subject

      expect(response).to redirect_to(
        user_journey_step_url(user_journey_id: user_journey.id, id: user_step.step.slug)
      )
    end
  end
end
