module Upvs
  class Assertion
    include ActiveModel::Model
    attr_accessor(:raw, :subject_name, :subject_id, :subject_ico)

    def self.new_from_xml(raw:)
      return unless raw

      h = Hash.from_xml(raw)
      new(
        raw:,
        subject_name: h.dig('Assertion', 'AttributeStatement', 'Attribute').detect{|e| e['Name'] == 'Subject.FormattedName' }.dig('AttributeValue'),
        subject_id: h.dig('Assertion', 'AttributeStatement', 'Attribute').detect{|e| e['Name'] == 'SubjectID' }.dig('AttributeValue'),
        subject_ico: h.dig('Assertion', 'AttributeStatement', 'Attribute').detect{|e| e['Name'] == 'Subject.ICO' }.dig('AttributeValue'),
      )
    end

    def self.assertion(eid_token, client: Faraday, url: "#{ENV.fetch('AUTH_EID_BASE_URL')}/api/upvs/assertion?token=#{eid_token&.api_token}")
      new_from_xml(raw: get_from_sk_api(client, url, eid_token))
    end

    def self.get_from_sk_api(client, url, eid_token)
      headers =  {
        "Accept": "application/samlassertion+xml",
        "AUTHORIZATION": "Bearer #{eid_token&.api_token}",
      }

      response = client.get(url, {}, headers)
      error =  begin
                 JSON.parse(response.body)
                rescue StandardError
                  nil
               end
      if error && error['message']
        return nil
      end
      response.body
    rescue StandardError => _e
      raise
      nil
    end


    class SkApiError < StandardError
    end
  end
end
