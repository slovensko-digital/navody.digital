require 'rails_helper'

RSpec.describe Admin::UploadsController, type: :controller do
  include AdminAuthHelper

  before(:each) do
    admin_http_login
  end

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

end
