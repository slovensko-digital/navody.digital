module Apps
  module BusinessRegisterApp
    class ActsSubmissionsController < ApplicationController
      def index
      end

      def search_business
        businesses = BusinessActs.new.search_business(params[:q])
        render json: { result: businesses }
      end

      def search_acts
        if params[:ico].present?
          business = BusinessActs.new.search_business(params[:ico])&.first
        else
          business = BusinessActs::Business.new(
            oddiel: params[:oddiel],
            vlozka: params[:vlozka],
            sud: params[:sud],
          )
        end

        acts = BusinessActs.new.search_acts(business)
        render json: { result: acts }
      end
    end
  end
end
