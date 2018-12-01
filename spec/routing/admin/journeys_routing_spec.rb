require "rails_helper"

RSpec.describe Admin::JourneysController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/journeys").to route_to("admin/journeys#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/journeys/new").to route_to("admin/journeys#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/journeys/1").to route_to("admin/journeys#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/journeys/1/edit").to route_to("admin/journeys#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/journeys").to route_to("admin/journeys#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/journeys/1").to route_to("admin/journeys#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/journeys/1").to route_to("admin/journeys#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/journeys/1").to route_to("admin/journeys#destroy", :id => "1")
    end
  end
end
