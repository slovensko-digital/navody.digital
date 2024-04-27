module Apps
  module ActsOrSrApp
    class ActsSubmissionsController < ApplicationController
      before_action :load_application_form, only: [:fill_submission, :form_check, :submit, :create]

      def search_business
        businesses = Apps::OrSrApp::ActsSubmission::BusinessActs.new.search_business(params[:q])
        render json: { result: businesses }
      end

      def index
        @application_form = Apps::OrSrApp::ActsSubmission::ApplicationForm.new

        render :index
      end

      def fill_submission
        (render action: :index and return) if @application_form.corporate_body_invalid?

        if @application_form.go_back?
          case @application_form.current_step
          when 'acts'
            index
          when 'email'
            acts(back: true)
          end
        elsif should_show_acts_list?
          acts
        elsif should_show_email?
          email
        else
          rerender_email
        end
      end

      def acts(back: false)
        parameters = acts_submission_params

        business = Apps::OrSrApp::ActsSubmission::BusinessActs.new.search_business(parameters['business_cin'])&.first
        @acts = Apps::OrSrApp::ActsSubmission::BusinessActs.new.search_acts(business)

        render :no_acts and return if @acts.empty?

        # to mark selected as checked
        if back
          acts_params = params.require(:apps_or_sr_app_acts_submission_application_form)[:acts]
          acts_list = JSON.parse(acts_params)

          acts_list.each do |a|
            @acts.select { |act| act.serial_number == a["id"] }.first.make_copy = true
          end
        end

        render :acts
      end

      def email(after_validation: false)
        current_step = params.require(:apps_or_sr_app_acts_submission_application_form)[:current_step]

        unless after_validation
          acts_params = params.require(:apps_or_sr_app_acts_submission_application_form)[:acts]
          acts_list = acts_params&.map { |a| JSON.parse(a) }
          @application_form.acts = acts_list
          @acts = acts_list.to_json
        end

        if current_step == 'acts' && @application_form.acts_invalid?
          acts and return
        else
          @application_form.email_invalid?
        end

        @submission_form = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new

        render :email
      end

      def form_check
        if @application_form.email_invalid?
          render json: { status: 'invalid' }
        else
          render json: { status: 'valid' }
        end
      end

      # generates XML to be submitted
      def create
        render json: { id: UpvsSubmissions::Forms::ApplicationForDocumentCopy.create_form_attachment(@application_form) }.to_json
      end

      def callback
      end

      private

      def rerender_email
        @acts = params.require(:apps_or_sr_app_acts_submission_application_form)[:acts]

        @application_form.email_invalid?

        @submission_form = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new

        render :email
      end

      def should_show_acts_list?
        @application_form.should_go_to_acts_list?
      end

      def should_show_email?
        @application_form.should_go_to_email?
      end

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
