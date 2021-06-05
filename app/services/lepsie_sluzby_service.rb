class LepsieSluzbyService
  class << self
  
    def create_issue(fields)
      issue = jira_client.Issue.build
      issue.save({
        "fields" => fields
      })
    end

    private

    def jira_client
      JIRA::Client.new({
        :username => ENV['JIRA_USERNAME'],
        :password => ENV['JIRA_PASSWORD'],
        :site     => "https://lepsiesluzby.sk/",
        :context_path => '/jira',
        :auth_type => :basic,
        :read_timeout => 120
      })
    end

  end
end


