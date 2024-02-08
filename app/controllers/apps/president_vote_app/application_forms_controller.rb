class Apps::PresidentVoteApp::ApplicationFormsController < ApplicationController
  helper FormatDaysHelper
  before_action :set_metadata, :check_inactive_president_application
  before_action :disable_feedback, only: [:show, :delivery, :create]

  def show
    render_step('start')
  end

  def delivery
    return render_self if request.post?
    render_step('delivery')
  end

  def permanent_resident
    return render_self if request.post?
    render_step('permanent_resident')
  end

  def create
    render_self
  end

  private def render_self
    @application_form = Apps::PresidentVoteApp::ApplicationForm.new(form_params)
    @application_form.run(self)
  end

  private def render_step(step)
    @application_form = Apps::PresidentVoteApp::ApplicationForm.new(step: step)
    render step
  end

  private def form_params
    params.require(:apps_president_vote_app_application_form).permit(
      :step,
      :place_first_round,
      :place_second_round,
      :sk_citizen,
      :delivery,
      :full_name, :pin, :nationality, :maiden_name,
      :authorized_person_full_name, :authorized_person_pin,
      :street, :pobox, :municipality,
      :same_delivery_address,
      :delivery_street, :delivery_pobox, :delivery_municipality, :delivery_country,
      :municipality_email,
      :municipality_email_verified,
      :permanent_resident,
      :back
    )
  end

  private def set_metadata
    @metadata.og.title = 'Žiadosť o hlasovací preukaz'
    @metadata.og.image = 'https://volby.digital/images/share-2024.png'
    @metadata.og.description = 'Aj keď budete počas volieb mimo trvalého pobytu, voliť sa dá. Stačí požiadať.'
  end

  private def check_inactive_president_application
    return if Apps::PresidentVoteApp::ApplicationForm.active?
    return redirect_to apps_president_vote_app_application_forms_path if action_name != "show"
    render 'inactive'
  end
end
