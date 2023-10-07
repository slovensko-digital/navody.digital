module Apps
  module GeneralAgendaApp
    class GeneralAgendaController < ApplicationController

      def index
        attributes = {
          title: params[:title].presence || 'Všeobecná agenda',
          description: params[:description].presence || 'Formulár pre odoslanie podania pre všeobecnú agendu',
          subject: params[:subject_placeholder],
          text: params[:text_placeholder],
          signed_required: params[:signed_required] || '1',
          text_hint: params[:text_hint],
          attachments_template: params[:attachments] || [{name: 'Subor 1', description: 'Popis suboru 1', signed_required: '1'},{name: 'Subor 2', description: 'Popis suboru 1', signed_required: '0'}],
        }.merge(general_agenda_params || {})

        @application_form = Apps::GeneralAgendaApp::GeneralAgenda::ApplicationForm.new(attributes)

        return render :invalid_template unless @application_form.valid_template?

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
          :signed_required,
          :attachments,
          :recipient_name,
          :recipient_uri,
          :is_submitted,
          :form_blob_id,
          # TODO :files,
        )
      end
    end
  end
end
