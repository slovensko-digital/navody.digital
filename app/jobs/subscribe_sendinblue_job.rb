class SubscribeSendinblueJob < ApplicationJob
  queue_as :default

  def perform(email, list_name)
    list = find_list(list_name)
    if list && list[:id]
      create_contact(email, list[:id])
    else
      raise "SubscribeSendinblueJob: Could not find list with name '#{list_name}'"
    end
  end

  private

  def find_list(list_name)
    Sendinblue::Lists.find_by_name(list_name)
  end

  def create_contact(email, list_id)
    Sendinblue::Contact.create(
      email: email,
      list_ids: [list_id],
      update_enabled: true,
    )
  end
end
