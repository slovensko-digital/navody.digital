require 'rails_helper'

RSpec.describe "NotificationSubscriptions", type: :request do
  describe "GET /notification_subscriptions" do
    it "works! (now write some real specs)" do
      get notification_subscriptions_path
      expect(response).to have_http_status(200)
    end
  end
end
