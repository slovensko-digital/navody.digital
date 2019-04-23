require "rails_helper"

RSpec.describe NotificationSubscriptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/notification_subscriptions").to route_to("notification_subscriptions#index")
    end

    it "routes to #new" do
      expect(:get => "/notification_subscriptions/new").to route_to("notification_subscriptions#new")
    end

    it "routes to #show" do
      expect(:get => "/notification_subscriptions/1").to route_to("notification_subscriptions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/notification_subscriptions/1/edit").to route_to("notification_subscriptions#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/notification_subscriptions").to route_to("notification_subscriptions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/notification_subscriptions/1").to route_to("notification_subscriptions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/notification_subscriptions/1").to route_to("notification_subscriptions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/notification_subscriptions/1").to route_to("notification_subscriptions#destroy", :id => "1")
    end
  end
end
