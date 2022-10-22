module Legal
  class ScheduleLawCheckJob < ApplicationJob
    queue_as :default

    def perform()
      Law.find_each{ |law| LawVersionsListJob.new.perform(law.id) }
      # TODO remove Laws that have no connection to Journeys
    end
  end
end
