class Law < ApplicationRecord
  has_many :journey_legal_definitions
  has_many :journeys, through: :journey_legal_definitions
  has_many :law_versions # TODO rename to just 'versions'?
  has_one :active_version, -> { where("valid_from < ? AND (valid_to > ? OR valid_to IS NULL)", Date.today, Date.today) }, class_name: 'LawVersion'
  delegate :valid_from, :valid_to, to: :active_version, allow_nil: true

  def last_update_at
    active_version.updated_at
  end
end
