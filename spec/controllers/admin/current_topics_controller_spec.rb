require 'rails_helper'

RSpec.describe Admin::CurrentTopicsController, type: :controller do
  include AdminAuthHelper

  before(:each) do
    admin_http_login
  end

  let(:valid_attributes) { build(:current_topic).attributes }
  let(:valid_session) { {} }

  describe "GET #index" do
    it "redirects to new action when there is no existing record" do
      get :index, params: {}, session: valid_session
      expect(response).to redirect_to(new_admin_current_topic_path)
    end

    it "redirects to existing current topic action when there is already record" do
      current_topic = create(:current_topic)
      get :index, params: {}, session: valid_session
      expect(response).to redirect_to(edit_admin_current_topic_path(current_topic) )
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      current_topic = create(:current_topic)
      get :edit, params: {id: current_topic.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new CurrentTopic" do
        expect {
          post :create, params: { current_topic: valid_attributes }, session: valid_session
        }.to change(CurrentTopic, :count).by(1)
        expect(response).to redirect_to(admin_current_topics_url)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {
          body: 'Foo bar'
        }
      }

      it "updates the requested page" do
        current_topic = create(:current_topic)
        put :update, params: {id: current_topic.to_param, current_topic: new_attributes}, session: valid_session
        current_topic.reload
        expect(current_topic.body).to eq 'Foo bar'
        expect(response).to redirect_to(admin_current_topics_url)
      end
    end
  end

end
