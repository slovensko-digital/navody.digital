module Sendinblue
  class Lists
    def self.find_by_name(name)
      limit = 50 # maximum limit
      page = 0

      opts = {
        limit: limit,
        offset: page * limit,
      }
      matched = nil

      loop do
        lists = api_instance.get_lists(opts).lists
        break if lists.empty?

        matched = lists.detect{|i| i[:name] == name }
        break if matched

        page += 1
        opts[:offset] = page * limit
      end

      matched
    end

    private

    def self.api_instance
      @api_instance ||= SibApiV3Sdk::ContactsApi.new
    end
  end
end
