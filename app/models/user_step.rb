class UserStep < ApplicationRecord
  belongs_to :step
  belongs_to :user_journey
end
