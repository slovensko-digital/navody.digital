require 'rails_helper'

RSpec.describe "admin/journeys/edit", type: :view do
  before(:each) do
    @journey = assign(:journey, create(:journey))
  end

  it "renders the edit journey form" do
    render

    assert_select "form[action=?][method=?]", admin_journey_path(@journey), "post" do
    end
  end
end
