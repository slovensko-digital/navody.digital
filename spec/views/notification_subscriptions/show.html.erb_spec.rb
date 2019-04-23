require 'rails_helper'

RSpec.describe "notification_subscriptions/show", type: :view do
  before(:each) do
    @notification_subscription = assign(:notification_subscription, NotificationSubscription.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
