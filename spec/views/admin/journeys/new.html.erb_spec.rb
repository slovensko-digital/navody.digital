require 'rails_helper'

RSpec.describe "admin/journeys/new", type: :view do
  before(:each) do
    assign(:journey, Journey.new)
  end

  it "renders new journey form" do
    render

    assert_select "form[action=?][method=?]", admin_journeys_path, "post" do
    end
  end
end
