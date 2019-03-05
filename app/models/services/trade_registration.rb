class Services::TradeRegistration < ActiveRecord::Base
  # belongs_to :user_step

  INSURANCE_COMPANIES = [
    OpenStruct.new(id: 'dovera', human_name: 'Dôvera'),
    OpenStruct.new(id: 'vszp', human_name: 'Všeobecná zdravotná poisťovňa'),
    OpenStruct.new(id: 'union', human_name: 'Union'),
  ]

  validates :first_name, :last_name, :birth_code, presence: true, if: Proc.new { |tr| tr.progress_step == 'personal_details' }
  validates :street_name, :street_number, :city, :postcode, presence: true, if: Proc.new { |tr| tr.progress_step == 'address' }
  validates :place_of_birth, :father_first_name, :father_last_name, :mother_first_name, :mother_last_name, :mother_maiden_name, presence: true, if: Proc.new { |tr| tr.progress_step == 'origin' }
  validates :health_insurance_company, presence: true, if: Proc.new { |tr| tr.progress_step == 'health_insurance' }
  validates :trade_name, presence: true, if: Proc.new { |tr| tr.progress_step == 'trade_name' }
  validates :trade_subjects, presence: true, if: Proc.new { |tr| tr.progress_step == 'trade_subjects' }

end
