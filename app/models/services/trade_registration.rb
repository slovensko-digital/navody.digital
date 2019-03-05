class Services::TradeRegistration < ActiveRecord::Base
  # belongs_to :user_step

  validates :first_name, :last_name, :birth_code, presence: true, if: Proc.new { |tr| tr.progress_step == 'personal_details' }
  validates :street_name, :street_number, :city, :postcode, presence: true, if: Proc.new { |tr| tr.progress_step == 'address' }
  validates :place_of_birth, :father_first_name, :father_last_name, :mother_first_name, :mother_last_name, :mother_maiden_name, presence: true, if: Proc.new { |tr| tr.progress_step == 'origin' }
end
