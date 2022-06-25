module My
  module CompanyRegisterStakeholderIdCheck
    class OrsrRecordError < StandardError; end

    class Job < ApplicationJob
      def perform(company, journey)
        ico = company.ico
        check_result = OrsrRecordChecker.call(ico)
        raise OrsrRecordError("Several active records found for one company id: #{ico}") if check_result.size > 1

        check_result = check_result.first

        entry = FeedEntry.find_or_initialize_by(user: company.user, thing: company, identifier: ico) do |entry|
          entry.deadline_at = Date.new(2022, 9, 30)
          entry.journey = journey
        end

        return if entry.new_record? && check_result[:missing].empty?

        return if entry.done? && check_result[:missing].empty?

        entry.last_checked_at = Time.now
        entry.custom_fields = check_result
        entry.status = check_result[:missing].any? ? :pending : :done

        entry.save!
      end
    end
  end
end
