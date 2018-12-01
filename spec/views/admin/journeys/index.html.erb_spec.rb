require 'rails_helper'

RSpec.describe "admin/journeys/index", type: :view do
  before(:each) do
    assign(:journeys, create_list(:journey, 2))
  end

  it "renders a list of admin/journeys" do
    render
  end
end
