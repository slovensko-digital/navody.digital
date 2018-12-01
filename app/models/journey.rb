class Journey < ApplicationRecord
  include Enums

  has_many :steps

  enumerates :published_status, with: %w{DRAFT PUBLISHED}
end