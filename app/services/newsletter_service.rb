class NewsletterService
  def self.create_contact(params)
    api_instance.create_contact(params)
  end

  def self.find_list(name)
    options = {
      limit: 50,
      offset: 0
    }
    result = api_instance.get_lists(options)
    total_pages = (result.count / options[:limit]) + 1

    total_pages.times do |n|
      matched = result.lists.detect{|i| i[:name] == name }
      return matched if matched
      return if (n+1) == total_pages

      options[:offset] = (n+1) * options[:limit]
      result = api_instance.get_lists(options)
    end
  end

  private

  def self.api_instance
    SibApiV3Sdk::ContactsApi.new
  end
end
