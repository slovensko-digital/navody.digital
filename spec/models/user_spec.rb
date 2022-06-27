require 'rails_helper'

RSpec.describe User, type: :model do
  it "should be possible to delete users with active journeys" do
    user = create(:user)
    journey = create(:journey)
    user_journey = create(:user_journey, user: user, journey: journey)

    # user.destroy
    expect(User.count).to eq(0)
    expect(UserJourney.count).to eq(0)
  end
end
