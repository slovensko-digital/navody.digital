module Apps
  module GeneralAgendaApp
    class GeneralAgendaController < ApplicationController
      before_action :load_application_form, only: [:fill_message]

      def search_recipient
        data = { name: 'Mesto Bratislava', uri: 'X' }, { name: 'Mesto Trnava', uri: 'Y' }
        result = data.select { |e| e[:name].to_s.downcase.include?(params[:q]) }

        render json: { result: result }
      end

      def index
        @application_form = Apps::GeneralAgendaApp::GeneralAgenda::ApplicationForm.new

        render :index
      end

      def fill_message
        rerender_confirmation if @application_form.valid?
      end

      # generates XML to be submitted
      def create
        xml_form = UpvsSubmissions::FormBuilders::ApplicationForDocumentCopyFormBuilder.build_form(@application_form)
        render xml: xml_form.to_xml
      end

      def callback
      end

      private

      def rerender_confirmation
        # @acts = params.require(:apps_or_sr_app_message_form_application_form)[:acts]
        #
        # @application_form.email_invalid?

        @submission_form = UpvsSubmissions::Forms::ApplicationForDocumentCopy.new

        render :confirmation
      end

      def load_application_form
        @application_form = GeneralAgendaApp::GeneralAgenda::ApplicationForm.new(message_form_params)
      end

      def message_form_params
        params.require(:apps_general_agenda_app_general_agenda_application_form).permit(
          :subject,
          :text,
          :recipient_name,
          :recipient_uri,
          :back,
          :current_step
        )
      end
    end
  end
end
