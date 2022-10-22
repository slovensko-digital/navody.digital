class Law < ApplicationRecord
  has_many :journey_legal_definitions
  has_many :journeys, through: :journey_legal_definitions
  has_many :law_versions # TODO rename to just 'versions'?
end
