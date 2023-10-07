module Datahub
  module Upvs
    class PublicAuthorityEdesksController < ApplicationController
      def search
        render json: PublicAuthorityEdesk.search(params[:q])
      end
    end
  end
end
