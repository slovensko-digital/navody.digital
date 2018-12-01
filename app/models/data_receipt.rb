class DataReceipt < ApplicationRecord
  before_create :generate_token

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end
end