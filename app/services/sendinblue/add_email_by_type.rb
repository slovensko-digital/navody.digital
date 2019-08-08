module Sendinblue
  class AddEmailByType
    def self.call(email, type)
      list_name = NotificationSubscription::TYPES.dig(type, :sendinblue_list_name)
      if list_name.present?
        SubscribeSendinblueJob.perform_later(email, list_name)
      end
    end
  end
end
