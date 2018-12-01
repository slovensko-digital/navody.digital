require "rails_helper"

RSpec.describe Admin::TasksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/tasks").to route_to("admin/tasks#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/tasks/new").to route_to("admin/tasks#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/tasks/1").to route_to("admin/tasks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/tasks/1/edit").to route_to("admin/tasks#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/tasks").to route_to("admin/tasks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/tasks/1").to route_to("admin/tasks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/tasks/1").to route_to("admin/tasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/tasks/1").to route_to("admin/tasks#destroy", :id => "1")
    end
  end
end
