class SaveCompanyWithMissingIdentifiersJob < ApplicationJob
  queue_as :default

  def perform(submission)
    cin = submission.extra.dig('params', 'company_cin')

    company_record = Apps::OrSrApp::StakeholdersIdentifiers::CompanyRecord.find_or_create_by({
      cin: Integer(cin)
    })

    company_record.update(:email => submission.user_email)
  end
end
