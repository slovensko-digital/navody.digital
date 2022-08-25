class Apps::OrSrApp::StakeholdersIdentifiersController < ApplicationController
  rescue_from OrSrRecordFetcher::OrsrRecordError, :with => :orsr_error

  def corporate_body_selection
  end

  def stakeholder_identifier
    if params.dig(:apps_or_sr_app_stakeholders_identifiers_application_form, :current_stakeholder_index)
      load_application_form
      update_stakeholder_identifier
    else
      load_data
    end

    next_step
  end

  def data_summary
  end

  def done
  end

  def unsupported
  end

  def nothing_missing
  end

  private

  def load_data
    cin = params.require(:cin)
    form_data = UpvsSubmissions::Forms::Fuzs.new(cin: cin)

    redirect_to action: :unsupported unless form_data.sro?
    redirect_to action: :nothing_missing if form_data.all_stakeholders_ok?

    @application_form = Apps::OrSrApp::StakeholdersIdentifiers::ApplicationForm.new(form_data: form_data)
  end

  def load_application_form
    form_parameters = form_params

    @application_form = Apps::OrSrApp::StakeholdersIdentifiers::ApplicationForm.new(
      json_form_data: form_parameters['json_form_data'],
      current_stakeholder_index: form_parameters['current_stakeholder_index'].to_i,
      back: form_parameters['back']
    )
  end

  def update_stakeholder_identifier
    identifier = params[:apps_or_sr_app_stakeholders_identifiers_application_form][:stakeholder_identifier]
    @application_form.form_data&.stakeholders[@application_form.current_stakeholder_index]&.identifier = identifier
  end

  def next_step
    if @application_form.current_stakeholder_index < @application_form.form_data&.stakeholders&.size - 1
      @application_form.current_stakeholder_index += 1
      @application_form.stakeholder = @application_form.form_data&.stakeholders[@application_form.current_stakeholder_index]
    else
      redirect_to action: :data_summary
    end
  end

  def form_params
    params.require(:apps_or_sr_app_stakeholders_identifiers_application_form).permit(
      :json_form_data,
      :stakeholder_identifier,
      :current_stakeholder_index,
      :back
    )
  end

  def orsr_error
    render :unsupported
  end
end
