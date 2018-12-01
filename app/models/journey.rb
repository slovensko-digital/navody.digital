class Journey < ApplicationRecord
  include Enums

  has_many :steps

  enumerates :published_status, with: %w{DRAFT PUBLISHED}

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :description, presence: true
end