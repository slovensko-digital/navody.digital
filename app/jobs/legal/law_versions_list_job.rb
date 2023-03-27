module Legal
  class LawVersionsListJob < ApplicationJob
    queue_as :default

    def perform(law)
      doc = Legal::SlovLexHelper.load_document(law.identifier)
      versions_raw = Legal::SlovLexHelper.parse_law_versions(doc)
      current_and_future_versions = Legal::SlovLexHelper.filter_current_and_future(versions_raw)
      current_and_future_versions.map do |version_row|
        record = LawVersion.find_or_initialize_by(law_id: law.id, identifier: version_row[:link_path]) do |law_version|
          law_version.valid_from = version_row[:valid_from]
          law_version.valid_to = version_row[:valid_to]
        end

        record.save!

        Legal::LawVersionJob.perform_later(record)
        record
      end
    end
  end
end
