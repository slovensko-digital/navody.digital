require "rails_helper"

RSpec.describe Admin::StepsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/journeys/1/steps").to route_to("admin/steps#index", journey_id: "1")
    end

    it "routes to #new" do
      expect(:get => "/admin/journeys/1/steps/new").to route_to("admin/steps#new", journey_id: "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/journeys/1/steps/1/edit").to route_to("admin/steps#edit", journey_id: "1", id: "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/journeys/1/steps").to route_to("admin/steps#create", journey_id: "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/journeys/1/steps/1").to route_to("admin/steps#update", journey_id: "1", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/journeys/1/steps/1").to route_to("admin/steps#update", journey_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/journeys/1/steps/1").to route_to("admin/steps#destroy", journey_id: "1", id: "1")
    end
  end
end
