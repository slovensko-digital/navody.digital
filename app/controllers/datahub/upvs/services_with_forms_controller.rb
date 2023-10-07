module Datahub
  module Upvs
    class ServicesWithFormsController < ApplicationController
      def search_recipient
        result = if testing?
                  # Datahub::Upvs::ServicesWithForms.search(params[:q])
                  [{ name: 'Testing - ico://sk/83369507', uri: 'ico://sk/83369507' }]
                 else
                  Datahub::Upvs::ServicesWithForms.search(params[:q])
                 end
        render json: { result: result }
      end

      private

      # Testing is determined based on the content of 'SLOVENSKO_SK_API_URL' which looks like e.g.:
      # - https://localhost:4000
      # - https://fix.slovensko-sk-api.staging.slovensko.digital
      #
      # If you need to see production list of recipients, change the `SLOVENSKO_SK_API_URL` ENV to something else
      def testing?
        ['staging.', 'localhost'].any? { |e| ENV['SLOVENSKO_SK_API_URL'].to_s.include?(e) }
      end
    end
  end
end
