class Services::TradeRegistration < ActiveRecord::Base
  # belongs_to :user_step
  has_many :trade_subjects
  accepts_nested_attributes_for :trade_subjects, reject_if: :all_blank, allow_destroy: true

  INSURANCE_COMPANIES = [
    OpenStruct.new(id: 'dovera', human_name: 'Dôvera', official_name: 'Dôvera zdravotná poisťovňa, a. s.', code: '24'),
    OpenStruct.new(id: 'vszp', human_name: 'Všeobecná zdravotná poisťovňa', official_name: 'Všeobecná zdravotná poisťovňa, a.s.', code: '25'),
    OpenStruct.new(id: 'union', human_name: 'Union', official_name: 'UNION zdravotná poisťovňa', code: '27'),
  ]

  validates :first_name, :last_name, :birth_code, presence: true, if: Proc.new { |tr| tr.progress_step == 'personal_details' }
  validates :street_name, :street_number, :city, :postcode, presence: true, if: Proc.new { |tr| tr.progress_step == 'address' }
  validates :place_of_birth, :father_first_name, :father_last_name, :mother_first_name, :mother_last_name, :mother_maiden_name, presence: true, if: Proc.new { |tr| tr.progress_step == 'origin' }
  validates :health_insurance_company_id, presence: true, if: Proc.new { |tr| tr.progress_step == 'health_insurance' }
  validates :trade_name, presence: true, if: Proc.new { |tr| tr.progress_step == 'trade_name' }
  validates :trade_subjects, presence: true, if: Proc.new { |tr| tr.progress_step == 'trade_subjects' }

  def email
    'TODO'
  end

  # def city
  #   OpenStruct.new(id: 'TODO', code: 'TODO', name: 'TODO', county: OpenStruct.new(name: 'TODO', office: OpenStruct.new(name: 'TODO', code: 'TODO')))
  # end
  #
  #
  def city_name
      city
  end

  def city_code
    'TODO'
  end

  def county
    OpenStruct.new(name: 'TODO', office: OpenStruct.new(name: 'TODO', code: 'TODO'))
  end

  def health_insurance_company
    INSURANCE_COMPANIES.detect { |ic| ic.id == health_insurance_company_id }
  end

  def date_of_birth
    return nil if birth_code.blank?

    year, month, day = birth_code.match(/^(\d{2})(\d{2})(\d{2})/).captures.map(&:to_i)
    year = year < 40 ? year + 2000 : year + 1900 # Convert 2-digit year to 4-digit
    month -= 50 if month > 50 # 50 is added to women's birth codes

    Date.new(year, month, day)
  end

  def gender
    return nil if birth_code.blank?

    _, month, _ = birth_code.match(/^(\d{2})(\d{2})(\d{2})/).captures.map(&:to_i)
    month > 50 ? 'Z' : 'M'
  end
end
