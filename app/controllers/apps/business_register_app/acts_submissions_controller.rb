module Apps
  module BusinessRegisterApp
    class ActsSubmissionsController < ApplicationController
      def search_business
        businesses = BusinessActs.new.search_business(params[:q])
        render json: { result: businesses }
      end

      # generates XML to be submitted
      def create
        @form = ActsSubmissionForm.new(acts_submission_params)
        xml_form = UpvsSubmissions::OrSrFormBuilder.new.application_for_document_copy(@form)
        render xml: xml_form.to_xml
      end

      def form_step1
      end

      def form_step2
        business = BusinessActs.new.search_business(params[:company_cin])&.first
        @acts = BusinessActs.new.search_acts(business)
      end

      def form_step3
        @acts = params[:acts].values.map { |a| JSON.parse(a) }.to_json
        @submission_form = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new
        @form = ActsSubmissionForm.new
      end

      def callback
      end

      private

      def acts_submission_params
        params.require(:acts_submission).permit(
          :business_cin,
          :business_name,
          :business_address,
          :business_section,
          :business_insertion,
          :business_court,
          :email,
          acts: [:id, :code, :name, :make_copy],
        )
      end
    end
  end
end
