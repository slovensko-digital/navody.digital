class ReportFeedbackLepsieSluzbyJob < ApplicationJob
  queue_as :default

  def perform(params)
    fields = build_JIRA_fields(params)
    LepsieSluzbyService.create_issue(fields)
  end

  private

  def build_JIRA_fields(params)
    fields = {
      "summary" => "Reported from navody.digital",
      "project" => {"key" => "SBX"},
      "description" => %Q(
        URL: #{params[:current_path]}
        feedback type: #{params[:feedback_type]}
        email: #{params[:email]}
        
        what you were doing:
        #{params[:bug_what_were_you_doing]}
        
        what went wrong:
        #{params[:bug_what_went_wrong]}
      ),
      "issuetype"=>{"id"=>10002}
    }
    return fields
  end
end
