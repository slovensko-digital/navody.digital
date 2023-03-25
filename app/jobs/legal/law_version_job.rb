module Legal
  class LawVersionJob < ApplicationJob
    queue_as :default

    def perform(law_version_id)
      law_version = LawVersion.find(law_version_id)
      identifier = law_version.law.identifier

      date_string = law_version.valid_from.to_s.gsub(/\-/, "")

      url = Legal::SlovLexLink.new(identifier).date_version(date_string: date_string)
      doc = Legal::SlovLexHelper.load_document(url)
      checksum = Legal::SlovLexHelper.count_checksum(doc)

      # we don't want to use dirty attributes, because don't want to save if checksum didn't change
      # but we want to fail if it changed and record is not valid
      if law_version.checksum != checksum
        law_version.checksum = checksum
        law_version.save!
      end
    end
  end
end
