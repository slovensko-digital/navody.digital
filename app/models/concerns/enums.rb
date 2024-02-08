module Enums
  extend ActiveSupport::Concern

  class_methods do
    def enumerates(attribute_name, with:)
      values = with.reduce({}) do |acc, item|
        acc[item] = item
        acc
      end

      enum(attribute_name, values)
    end
  end
end
