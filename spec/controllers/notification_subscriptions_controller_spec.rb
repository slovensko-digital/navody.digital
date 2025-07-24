require 'rails_helper'

RSpec.describe NotificationSubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:blank_journey) { create(:journey, published_status: "BLANK") }

  describe "POST #create" do
    let(:valid_params) do
      {
        notification_subscription_group: {
          email: 'test@example.com',
          selected_subscription_types: ['VoteSubscription'],
          subscription_types: ['VoteSubscription']
        },
        altcha: Base64.encode64('{"test": "data"}')
      }
    end

    let(:blank_journey_params) do
      {
        notification_subscription_group: {
          email: 'test@example.com',
          selected_subscription_types: ['BlankJourneySubscription'],
          subscription_types: ['BlankJourneySubscription'],
          journey_id: blank_journey.id
        },
        altcha: Base64.encode64('{"test": "data"}')
      }
    end

    before do
      allow(AltchaSolution).to receive(:verify_and_save).and_return(true)
    end

    context "as an anonymous user" do
      it "creates a notification subscription group" do
        post :create, params: valid_params, xhr: true
        expect(assigns(:group)).to be_a(NotificationSubscriptionGroup)
        expect(response).to have_http_status(:success)
      end

      it "subscribes to blank journey notification" do
        post :create, params: blank_journey_params, xhr: true
        expect(assigns(:group).journey).to eq(blank_journey)
        expect(response).to have_http_status(:success)
      end

      it "assigns anonymous user to the group" do
        post :create, params: valid_params, xhr: true
        expect(assigns(:group).user).to be_a(AnonymousUser)
      end
    end

    context "as a logged in user" do
      before do
        session[:user_id] = user.id
      end

      it "creates a notification subscription group" do
        post :create, params: valid_params, xhr: true
        expect(assigns(:group)).to be_a(NotificationSubscriptionGroup)
        expect(response).to have_http_status(:success)
      end

      it "subscribes to blank journey notification" do
        post :create, params: blank_journey_params, xhr: true
        expect(assigns(:group).user).to eq(user)
        expect(assigns(:group).journey).to eq(blank_journey)
      end

      it "assigns current_user to the group" do
        post :create, params: valid_params, xhr: true
        expect(assigns(:group).user).to eq(user)
      end
    end

    context "when ALTCHA verification fails" do
      before do
        allow(AltchaSolution).to receive(:verify_and_save).and_return(false)
      end

      it "renders failure template" do
        post :create, params: valid_params, xhr: true
        expect(response).to render_template(:failure)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when save fails" do
      before do
        allow_any_instance_of(NotificationSubscriptionGroup).to receive(:save).and_return(false)
      end

      it "renders the new template" do
        post :create, params: valid_params, xhr: true
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #confirm" do
    let!(:subscription1) { create(:notification_subscription, confirmation_token: 'token123') }
    let!(:subscription2) { create(:notification_subscription, confirmation_token: 'token123') }

    before do
      allow(subscription1).to receive(:confirm)
      allow(subscription2).to receive(:confirm)
      allow(NotificationSubscription).to receive(:where).with(confirmation_token: 'token123')
                                                           .and_return([subscription1, subscription2])
    end

    it "finds and confirms subscriptions by token" do
      expect(subscription1).to receive(:confirm)
      expect(subscription2).to receive(:confirm)

      get :confirm, params: { id: 'token123' }

      expect(assigns(:subscriptions)).to contain_exactly(subscription1, subscription2)
      expect(response).to have_http_status(:success)
    end
  end
end
