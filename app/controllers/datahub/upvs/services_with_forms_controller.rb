module Datahub
  module Upvs
    class ServicesWithFormsController < ApplicationController
      def search
        render json: Datahub::Upvs::ServicesWithForms.search(params[:q])
      end
    end
  end
end
