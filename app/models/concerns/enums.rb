module Enums
  extend ActiveSupport::Concern

  class_methods do
    def enumerates(attribute_name, with:)
      enum({
          attribute_name => with.reduce({}) do |acc, item|
            acc[item] = item
            acc
          end
      })
    end
  end
end