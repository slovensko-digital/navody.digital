module Apps
  module OrSrApp
    class ActsSubmissionsController < ApplicationController
      before_action :load_application_form, only: [:acts, :email, :submit, :create]

      def search_business
        businesses = Apps::OrSrApp::ActsSubmission::BusinessActs.new.search_business(params[:q])
        render json: { result: businesses }
      end

      def subject_selection
        @application_form = Apps::OrSrApp::ActsSubmission::ApplicationForm.new
      end

      def acts
        if @application_form.cb_invalid?
          redirect_to action: :subject_selection
        else
          parameters = acts_submission_params

          business = Apps::OrSrApp::ActsSubmission::BusinessActs.new.search_business(parameters['business_cin'])&.first
          @acts = Apps::OrSrApp::ActsSubmission::BusinessActs.new.search_acts(business)
        end
      end

      def email
        acts = params.require(:apps_or_sr_app_acts_submission_application_form)[:acts]

        @acts = acts.map { |a| JSON.parse(a) }.to_json
        @submission_form = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new
      end

      # generates XML to be submitted
      def create
        xml_form = UpvsSubmissions::OrSrFormBuilder.new.application_for_document_copy(@application_form)
        render xml: xml_form.to_xml
      end

      def callback
      end

      private

      def load_application_form
        @application_form = OrSrApp::ActsSubmission::ApplicationForm.new(acts_submission_params)
      end

      def acts_submission_params
        params.require(:apps_or_sr_app_acts_submission_application_form).permit(
          :business_cin,
          :business_name,
          :business_address,
          :business_section,
          :business_insertion,
          :business_court,
          :email,
          :back,
          :current_step,
          acts: [:id, :code, :name, :make_copy]
        )
      end
    end
  end
end
