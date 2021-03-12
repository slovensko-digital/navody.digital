class AddEmailToContactListJob < ApplicationJob
  queue_as :default

  def perform(email, list_name)
    list = EmailService.find_list(list_name)

    raise "Contact list not found: #{list_name}" unless list || list[:id]

    EmailService.create_contact(email: email, listIds: [list_id], updateEnabled: true)
  end
end
