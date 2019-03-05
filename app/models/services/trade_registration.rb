class Services::TradeRegistration < ActiveRecord::Base
  # belongs_to :user_step

  validates :first_name, :last_name, :birth_code, presence: true
  validates :street_name, presence: true
end
