class EmailMeOrSrIdentifiersStatusEmailJob < ApplicationJob
  queue_as :default

  def perform
    Apps::OrSrApp::StakeholdersIdentifiers::CompanyRecord.where(identifiers_ok: false).each do |company_record|
      or_sr_document = OrSrRecordFetcher.get_document(company_record.cin)
      current_identifiers_status = OrSrRecordFetcher.get_stakeholders_identifiers_status(or_sr_document)

      if current_identifiers_status[:missing].size == 0
        company_record.update(:identifiers_ok => true)

        email = build_template_email(company_record)
        EmailService.send_email(email)
      end
    end
  end

  private

  def build_template_email(company_record)
    # TODO templateID
    {
      templateId: 0,
      params: email_params(company_record),
      to: [{ email: company_record.email }]
    }
  end

  def email_params(company_record)
    {
      company_name: company_record.name,
      company_cin: company_record.cin
    }
  end
end
