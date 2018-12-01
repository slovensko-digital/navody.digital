require "rails_helper"

RSpec.describe Admin::TasksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/journeys/1/steps/2/tasks").to route_to("admin/tasks#index", journey_id: "1", step_id: "2")
    end

    it "routes to #new" do
      expect(:get => "/admin/journeys/1/steps/2/tasks/new").to route_to("admin/tasks#new", journey_id: "1", step_id: "2")
    end

    it "routes to #show" do
      expect(:get => "/admin/journeys/1/steps/2/tasks/1").to route_to("admin/tasks#show", journey_id: "1", step_id: "2", id: "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/journeys/1/steps/2/tasks/1/edit").to route_to("admin/tasks#edit", journey_id: "1", step_id: "2", id: "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/journeys/1/steps/2/tasks").to route_to("admin/tasks#create", journey_id: "1", step_id: "2")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/journeys/1/steps/2/tasks/1").to route_to("admin/tasks#update", journey_id: "1", step_id: "2", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/journeys/1/steps/2/tasks/1").to route_to("admin/tasks#update", journey_id: "1", step_id: "2", id: "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/journeys/1/steps/2/tasks/1").to route_to("admin/tasks#destroy", journey_id: "1", step_id: "2", id: "1")
    end
  end
end
