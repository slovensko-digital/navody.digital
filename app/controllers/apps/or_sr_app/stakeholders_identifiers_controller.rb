class Apps::OrSrApp::StakeholdersIdentifiersController < ApplicationController
  before_action :load_application_form, only: [:stakeholder_identifier, :xml_form, :generate_xml_form]
  before_action :set_metadata, only: [:subject_selection]

  rescue_from OrSrRecordFetcher::OrsrRecordError, UpvsSubmissions::Forms::FuzsData::FuzsError, StandardError, :with => :handle_error

  def subject_selection
    @application_form = Apps::OrSrApp::StakeholdersIdentifiers::ApplicationForm.new
  end

  def stakeholder_identifier
    (render action: :subject_selection and return) if @application_form.corporate_body_invalid?

    if currently_showing_stakeholder?
      update_stakeholder_identifier if identifier_present?

      if @application_form.go_back? or @application_form.identifiers_valid?
        next_step
      else
        render :stakeholder_identifier and return
      end
    else
      load_data
      next_step
    end
  end

  def stakeholders_summary
    @stakeholders = @application_form.form_data&.stakeholders_with_missing_identifiers
    @xml_form = Base64.encode64(UpvsSubmissions::OrSrFormBuilder.fuzs_missing_identifiers(@application_form.form_data))

    render :stakeholders_summary
  end

  def unsupported
  end

  def nothing_missing
  end

  private

  def load_data
    parameters = params.require(:apps_or_sr_app_stakeholders_identifiers_application_form).permit(:cin, :current_step)
    form_data = UpvsSubmissions::Forms::FuzsData.new(cin: parameters['cin'])

    @application_form = Apps::OrSrApp::StakeholdersIdentifiers::ApplicationForm.new(cin: parameters['cin'], form_data: form_data)
  end

  def load_application_form
    form_parameters = form_params

    @application_form = Apps::OrSrApp::StakeholdersIdentifiers::ApplicationForm.new(
      cin: form_parameters['cin'].presence,
      json_form_data: form_parameters['json_form_data'],
      stakeholder_nationality: form_parameters['stakeholder_nationality'],
      stakeholder_identifier: form_parameters['stakeholder_identifier'].presence,
      stakeholder_other_identifier: form_parameters['stakeholder_other_identifier'].presence,
      stakeholder_other_identifier_type: form_parameters['stakeholder_other_identifier_type'],
      stakeholder_dob_year: form_parameters['stakeholder_dob_year'].presence,
      stakeholder_dob_month: form_parameters['stakeholder_dob_month'].presence,
      stakeholder_dob_day: form_parameters['stakeholder_dob_day'].presence,
      current_stakeholder_index: (form_parameters['current_stakeholder_index'] ? form_parameters['current_stakeholder_index'].to_i : -1),
      current_step: form_parameters['current_step'],
      go_to_summary: form_parameters['go_to_summary'],
      back: form_parameters['back']
    )
    @application_form.stakeholder = current_stakeholder
  end

  def update_stakeholder_identifier
    current_stakeholder&.set_if_foreign(nationality: param_value(:stakeholder_nationality))
    current_stakeholder&.set_date_of_birth(
      year: param_value(:stakeholder_dob_year),
      month: param_value(:stakeholder_dob_month),
      day: param_value(:stakeholder_dob_day)
    )
    current_stakeholder&.set_identifiers(
      identifier: param_value(:stakeholder_identifier).presence,
      other_identifier: param_value(:stakeholder_other_identifier).presence,
      other_identifier_type: param_value(:stakeholder_other_identifier_type)
    )
  end

  def next_step
    redirect_to action: :unsupported and return unless @application_form.form_data&.sro?
    redirect_to action: :nothing_missing and return if @application_form.form_data&.all_stakeholders_ok?

    if @application_form.go_back?
      case @application_form.current_step
      when 'save'
        if @application_form.current_stakeholder_index > 0
          @application_form.current_stakeholder_index -= 1
          @application_form.stakeholder = current_stakeholder
          render :stakeholder_identifier and return
        else
          render :subject_selection and return
        end
      when 'edit'
        stakeholders_summary
      when 'summary'
        @application_form.stakeholder = current_stakeholder
        render :stakeholder_identifier and return
      when 'xml'
        stakeholders_summary
      end
    elsif should_show_summary?
      stakeholders_summary
    else
      @application_form.current_stakeholder_index += 1
      @application_form.stakeholder = current_stakeholder
      render :stakeholder_identifier
    end
  end

  def form_params
    params.require(:apps_or_sr_app_stakeholders_identifiers_application_form).permit(
      :cin,
      :json_form_data,
      :stakeholder_nationality,
      :stakeholder_identifier,
      :stakeholder_other_identifier,
      :stakeholder_other_identifier_type,
      :stakeholder_dob_year,
      :stakeholder_dob_month,
      :stakeholder_dob_day,
      :current_stakeholder_index,
      :current_step,
      :go_to_summary,
      :back
    )
  end

  def current_stakeholder
    @application_form.form_data&.stakeholders_with_missing_identifiers[@application_form.current_stakeholder_index] if @application_form.current_stakeholder_index >= 0
  end

  def should_show_summary?
    @application_form.should_go_to_summary?
  end

  def param_value(attribute)
    params[:apps_or_sr_app_stakeholders_identifiers_application_form][attribute]
  end

  def currently_showing_stakeholder?
    params.dig(:apps_or_sr_app_stakeholders_identifiers_application_form, :current_stakeholder_index)
  end

  def identifier_present?
    params.dig(:apps_or_sr_app_stakeholders_identifiers_application_form, :stakeholder_identifier)
  end

  def set_metadata
    @metadata.og.title = 'Povinnosť zápisu chýbajúcich identifikačných údajov spoločníkov do obchodného registra'
    @metadata.og.description = 'Zistite, či má Vaša spoločnosť splnenú túto zákonnú povinnosť a vybavte návrh na zápis online, jednoducho, len na pár klikov.'
    # TODO
    # @metadata.og.image = ''
  end

  def handle_error
    redirect_to action: :unsupported
  end
end
