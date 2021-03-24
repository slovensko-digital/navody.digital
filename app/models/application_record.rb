class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def normalize_blank_attributes
    attributes.keys.each do |column|
      self[column] = nil if self[column]&.strip.blank?
    end
  end
end
