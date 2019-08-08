module Sendinblue
  class Lists
    def self.find_by_name(name)
      options = {
        limit: 50,
        offset: 0
      }
      result = api_instance.get_lists(options)
      total_pages = (result.count / options[:limit]) + 1

      total_pages.times do |n|
        matched = result.lists.detect{|i| i[:name] == name }
        return matched if matched

        options[:offset] = (n+1) * options[:limit]
        result = api_instance.get_lists(options)
      end

      nil
    end

    private

    def self.api_instance
      @api_instance ||= SibApiV3Sdk::ContactsApi.new
    end
  end
end
