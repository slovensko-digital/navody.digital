module Apps
  module BusinessRegisterApp
    class ActsSubmissionsController < ApplicationController
      def index
        @form = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new
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

      # generates XML to be submitted
      def create
        xml_form = UpvsSubmissions::OrSrFormBuilder.new.application_for_document_copy(acts_submission_params)
        xml_form.to_xml
      end

      def callback
      end

      private

      def acts_submission_params
        params.require(:acts_submission).permit(
          :business_ico,
          :business_name,
          :business_address,
          :email,
          acts: [:make_copy, :code, :name],
        )
      end
    end
  end
end
