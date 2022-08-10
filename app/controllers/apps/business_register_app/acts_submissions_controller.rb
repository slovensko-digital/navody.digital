module Apps
  module BusinessRegisterApp
    class ActsSubmissionsController < ApplicationController
      before_action :load_form, only: [:step2, :step3, :submit, :create]

      def search_business
        businesses = BusinessActs.new.search_business(params[:q])
        render json: { result: businesses }
      end

      # generates XML to be submitted
      def create
        xml_form = UpvsSubmissions::OrSrFormBuilder.new.application_for_document_copy(@form)
        render xml: xml_form.to_xml
      end

      def step1
      end

      def step2
        if @form.errors[:business_cin].any?
          format.js { render :new, @form_template = 'form_step1' }
        else
          business = BusinessActs.new.search_business(params[:acts_submission][:business_cin])&.first
          @acts = BusinessActs.new.search_acts(business)
        end
      end

      def step3
        @acts = params[:acts].values.map { |a| JSON.parse(a) }.to_json
        @submission_form = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new
      end

      def submit

      end

      def callback
      end

      private

      def load_form
        @form = ActsSubmissionForm.new(acts_submission_params)
        @form.valid?
        @form
      end

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
