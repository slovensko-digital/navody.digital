class JourneyLegalDefinition < ApplicationRecord
  belongs_to :journey
  belongs_to :law
end
