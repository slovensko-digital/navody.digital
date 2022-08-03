require "rails_helper"

RSpec.describe Admin::CategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/categories").to route_to("admin/categories#index")
    end

    it "routes to #new" do
      expect(get: "/admin/categories/new").to route_to("admin/categories#new")
    end

    it "routes to #show" do
      expect(get: "/admin/categories/1").to route_to("admin/categories#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/categories/1/edit").to route_to("admin/categories#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/admin/categories").to route_to("admin/categories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/categories/1").to route_to("admin/categories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/categories/1").to route_to("admin/categories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/categories/1").to route_to("admin/categories#destroy", id: "1")
    end
  end
end
