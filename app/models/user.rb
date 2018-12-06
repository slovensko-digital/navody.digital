class User < ApplicationRecord
  has_many :user_journeys do
    def start!(journey)
      create!(journey: journey)
    end
  end

  has_many :user_steps, through: :user_journeys
  has_many :user_tasks, through: :user_steps
end
