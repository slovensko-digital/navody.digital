module My
  module CompanyRegisterStakeholderIdCheck
    class FeedEntryGenerator < My::FeedEntryGenerator
      def run
        My::Company.find_each do |company|
          My::CompanyRegisterStakeholderIdCheck::Job.perform_later(company, journey)
        end
      end
    end
  end
end
