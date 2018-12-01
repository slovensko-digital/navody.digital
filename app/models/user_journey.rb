class UserJourney < ApplicationRecord
  belongs_to :journey
  belongs_to :user

  has_many :user_steps
end
