require "rails_helper"

RSpec.describe Admin::StepsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/steps").to route_to("admin/steps#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/steps/new").to route_to("admin/steps#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/steps/1").to route_to("admin/steps#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/steps/1/edit").to route_to("admin/steps#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/steps").to route_to("admin/steps#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/steps/1").to route_to("admin/steps#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/steps/1").to route_to("admin/steps#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/steps/1").to route_to("admin/steps#destroy", :id => "1")
    end
  end
end
