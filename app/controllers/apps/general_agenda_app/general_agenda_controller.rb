module Apps
  module GeneralAgendaApp
    class GeneralAgendaController < ApplicationController
      skip_forgery_protection only: [:index]

      def index
        # Configuration of the form - as API
        attributes = {
          title: params[:title].presence || 'Všeobecná agenda',
          description: params[:description].presence || 'Formulár pre odoslanie podania pre všeobecnú agendu',
          subject: params[:subject_placeholder],
          text: params[:text_placeholder],
          signed_required: params[:signed_required],
          text_hint: params[:text_hint],
          attachments_template: params[:attachments_template] || [{name: 'F1', signed_required: '1'}, {name: 'F2', signed_required: '0', required: '1'}]
        }.with_indifferent_access

        # Appending whatever user submitted into recipient, subject, text and attachments
        # + remembers the form configuration between submits
        attributes.merge!(general_agenda_params || {})

        @application_form = Apps::GeneralAgendaApp::GeneralAgenda::ApplicationForm.new(attributes)

        return render :invalid_template unless @application_form.valid_template?

        redirect_to_upvs_submission if @application_form.is_submitted && @application_form.valid?
      end

      def callback
      end

      private

      def redirect_to_upvs_submission
        @submission_form = UpvsSubmissions::Forms::GeneralAgenda.new(@application_form)

        render :redirect_to_upvs_submission
      end

      def general_agenda_params
        params[:apps_general_agenda_app_general_agenda_application_form]&.permit(
          :title,
          :description,
          :subject,
          :text,
          :text_hint,
          :signed_required,
          :recipient_name,
          :recipient_uri,
          :is_submitted,
          attachments: {},
          attachments_template: [:name, :description, :required, :signed_required]
        )
      end
    end
  end
end
