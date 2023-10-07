module Apps
  module GeneralAgendaApp
    class GeneralAgendaController < ApplicationController

      def index
        attributes = {
          title: params[:title].presence || 'Všeobecná agenda',
          description: params[:description].presence || 'Formulár pre odoslanie podania pre všeobecnú agendu',
          subject: params[:subject_placeholder],
          text: params[:text_placeholder],
          signed_required: params[:signed_required],
          text_hint: params[:text_hint],
          attachments_template: params[:attachments],
        }.merge(general_agenda_params || {})

        @application_form = Apps::GeneralAgendaApp::GeneralAgenda::ApplicationForm.new(attributes)

        redirect_to_upvs_submission if @application_form.is_submitted && @application_form.valid?
      end

      def callback
      end

      private

      def redirect_to_upvs_submission
        @submission_form = UpvsSubmissions::Forms::GeneralAgenda.new(form_params: @application_form)

        render :redirect_to_upvs_submission
      end

      def general_agenda_params
        params[:apps_general_agenda_app_general_agenda_application_form]&.permit(
          :title,
          :description,
          :attachments_template,
          :subject,
          :text,
          :attachments,
          :recipient_name,
          :recipient_uri,
          :is_submitted
        )
      end
    end
  end
end
