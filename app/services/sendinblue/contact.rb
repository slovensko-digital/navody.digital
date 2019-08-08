module Sendinblue
  class Contact
    def self.create(params)
      api_instance.create_contact(params)
    end

    private

    def self.api_instance
      @api_instance ||= SibApiV3Sdk::ContactsApi.new
    end
  end
end
