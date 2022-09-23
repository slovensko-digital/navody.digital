class SaveCompanyWithMissingIdentifiersJob < ApplicationJob
  queue_as :default

  def perform(submission)
    company_name = submission.extra.dig('params', 'company_name')
    cin = submission.extra.dig('params', 'company_cin')

    company_record = Apps::OrSrApp::StakeholdersIdentifiers::CompanyRecord.find_or_create_by({
      name: company_name,
      cin: Integer(cin)
    })

    company_record.update(:email => submission.user_email)
  end
end
