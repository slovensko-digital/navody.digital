class EmailMeOrSrIdentifiersStatusEmail < ApplicationJob
  queue_as :default

  def perform
    Apps::OrSrApp::StakeholdersIdentifiers::CompanyRecord.where(identifiers_ok: false) do |company_record|
      or_sr_document = OrSrRecordFetcher.get_document(company_record.cin)
      current_identifiers_status = OrSrRecordFetcher.get_stakeholders_identifiers_status(or_sr_document)

      if current_identifiers_status[:missing].size == 0
        company_record.update(:identifiers_ok => true)

        # TODO send email
      end
    end
  end
end
