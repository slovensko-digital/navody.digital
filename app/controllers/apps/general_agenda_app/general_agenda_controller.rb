module Apps
  module GeneralAgendaApp
    class GeneralAgendaController < ApplicationController
      before_action :load_application_form, only: [:fill_message]
      def index
        @application_form = Apps::GeneralAgendaApp::GeneralAgenda::ApplicationForm.new

        render :index
      end

      def fill_message
        return render action: :index unless @application_form.valid?(:recipient_uri)

        redirect_to_upvs_submission if @application_form.should_redirect_to_upvs_submission?
      end

      def callback
      end

      private

      def redirect_to_upvs_submission
        @submission_form = UpvsSubmissions::Forms::GeneralAgenda.new(form_params: @application_form)

        render :redirect_to_upvs_submission
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
          :current_step
        )
      end
    end
  end
end
