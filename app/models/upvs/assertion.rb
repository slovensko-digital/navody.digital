module Upvs
  class Assertion
    include ActiveModel::Model
    attr_accessor(:raw, :subject_name, :subject_id, :subject_cin, :subject_edesk_number)

    def self.new_from_xml(raw:)
      return unless raw

      doc  = Nokogiri::XML(raw)
      return unless doc

      doc.remove_namespaces!
      doc_attrs = doc.xpath('//Assertion/AttributeStatement/Attribute')
      return unless doc_attrs

      new(
        raw:,
        subject_name: doc_attrs.detect{|n| n['Name'] == 'Subject.FormattedName' }&.xpath('AttributeValue')&.text,
        subject_id: doc_attrs.detect{|n| n['Name'] == 'SubjectID' }&.xpath('AttributeValue')&.text,
        subject_cin: doc_attrs.detect{|n| n['Name'] == 'Subject.ICO' }&.xpath('AttributeValue')&.text,
        subject_edesk_number: doc_attrs.detect{|n| n['Name'] == 'Subject.eDeskNumber' }&.xpath('AttributeValue')&.text,
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
