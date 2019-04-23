require 'rails_helper'

RSpec.describe "notification_subscriptions/index", type: :view do
  before(:each) do
    assign(:notification_subscriptions, [
      NotificationSubscription.create!(),
      NotificationSubscription.create!()
    ])
  end

  it "renders a list of notification_subscriptions" do
    render
  end
end
