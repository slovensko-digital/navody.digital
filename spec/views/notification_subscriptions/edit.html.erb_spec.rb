require 'rails_helper'

RSpec.describe "notification_subscriptions/edit", type: :view do
  before(:each) do
    @notification_subscription = assign(:notification_subscription, NotificationSubscription.create!())
  end

  it "renders the edit notification_subscription form" do
    render

    assert_select "form[action=?][method=?]", notification_subscription_path(@notification_subscription), "post" do
    end
  end
end
