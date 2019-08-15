class SubscribeSendinblueJob < ApplicationJob
  queue_as :default

  def perform(email, list_name)
    list = find_list(list_name)
    if list && list[:id]
      create_contact(email, list[:id])
    else
      raise "#{self.class.name}: Could not find list with name '#{list_name}'"
    end
  end

  private

  def find_list(name)
    NewsletterService.find_list(name)
  end

  def create_contact(email, list_id)
    NewsletterService.create_contact(
      email: email,
      listIds: [list_id],
      updateEnabled: true,
    )
  end
end
