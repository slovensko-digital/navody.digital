class My::UserFeedEntry < ApplicationRecord
  self.abstract_class = true

  belongs_to :user
  belongs_to :thing
  belongs_to :journey
end
