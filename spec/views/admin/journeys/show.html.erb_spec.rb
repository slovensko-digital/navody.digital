require 'rails_helper'

RSpec.describe "admin/journeys/show", type: :view do
  before(:each) do
    @journey = assign(:journey, create(:journey))
  end

  it "renders attributes in <p>" do
    render
  end
end
