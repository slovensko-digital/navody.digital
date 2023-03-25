module Legal
  class ScheduleLawCheckJob < ApplicationJob
    queue_as :default

    def perform
      Law.find_each{ |law| LawVersionsListJob.perform_later(law) }
      # TODO remove Laws that have no connection to Journeys
    end
  end
end
