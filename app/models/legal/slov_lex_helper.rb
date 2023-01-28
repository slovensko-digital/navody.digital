module Legal
  module SlovLexHelper
    def self.count_checksum(doc)
      body = doc.css('.predpisFullWidth > .span8') # vytiahnut iba textove znenie zakona
      Digest::SHA512.hexdigest(body.to_s)
    end

    def self.is_valid_law_identifier?(identifier)
      doc = load_document(identifier)
      parse_law_versions(doc).any?
    end

    def self.load_document(url)
      law_link = Legal::SlovLexLink.new(url).current_date_version
      response = HTTP.get(law_link)
      Nokogiri::HTML(response.to_s)
    end

    def self.parse_law_versions(doc)
      versions = doc.css("tr.effectivenessHistoryItem")
      return [] unless versions.any?

      versions.to_a[1..].map do |tr|
        {
          valid_from: parse_date(tr.attributes["data-ucinnostod"].value),
          valid_to: parse_date(tr.attributes["data-ucinnostdo"].value),
          link_path: tr.attributes["data-iri"].value # law version identifier
        }
      end
    end

    def self.filter_current_and_future(rows)
      rows.select{ |row| is_current_version(row) || is_future_version(row) }
    end

    def self.is_current_version(row)
      current_date = Date.current

      if row[:valid_from] <= current_date
        return (row[:valid_to] ? current_date <= row[:valid_to] : true)
      end
    end

    def self.is_future_version(row)
      current_date = Date.current

      row[:valid_from] > current_date
    end

    def self.parse_date(date_string)
      if date_string.present?
        Date.parse(date_string)
      else
        nil
      end
    end
  end
end
