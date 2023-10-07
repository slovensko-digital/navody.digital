module Datahub
  module Upvs
    class ServicesWithFormsController < ApplicationController
      def search_recipient
        result = Datahub::Upvs::PublicAuthorityEdesk.search(params[:q])
        render json: { result: result }
      end
    end
  end
end
