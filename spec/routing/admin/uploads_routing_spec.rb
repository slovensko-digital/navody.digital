require "rails_helper"

RSpec.describe Admin::UploadsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/uploads").to route_to("admin/uploads#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/uploads/new").to route_to("admin/uploads#new")
    end

    it "routes to #create" do
      expect(:post => "/admin/uploads").to route_to("admin/uploads#create")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/uploads/1").to route_to("admin/uploads#destroy", :id => "1")
    end
  end
end
