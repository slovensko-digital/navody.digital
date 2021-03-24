class SubscribeToNewsletterJob < ApplicationJob
  queue_as :default

  def perform(email, list_name)
    EmailService.subscribe_to_newsletter(email, list_name)
  end
end
