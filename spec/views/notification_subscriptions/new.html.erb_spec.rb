require 'rails_helper'

RSpec.describe "notification_subscriptions/new", type: :view do
  before(:each) do
    assign(:notification_subscription, NotificationSubscription.new())
  end

  it "renders new notification_subscription form" do
    render

    assert_select "form[action=?][method=?]", notification_subscriptions_path, "post" do
    end
  end
end
