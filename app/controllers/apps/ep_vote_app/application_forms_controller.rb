class Apps::EpVoteApp::ApplicationFormsController < ApplicationController
  helper FormatDaysHelper
  before_action :set_metadata, :check_inactive_ep_application, :disable_current_topic
  before_action :disable_feedback, only: [:show, :delivery, :create, :send_email, :authorized_person_send]

  def show
    render_step('start')
  end

  def delivery
    return render_self if request.post?
    render_step('delivery')
  end

  def create
    render_self
  end

  def authorized_person_send
    return render_self if request.post?
    redirect_to delivery_apps_ep_vote_app_application_forms_path
  end

  def send_email
    return render_self if request.post?
    redirect_to delivery_apps_ep_vote_app_application_forms_path
  end

  private def render_self
    @application_form = Apps::EpVoteApp::ApplicationForm.new(form_params)
    @application_form.run(self)
  end

  private def render_step(step)
    @application_form = Apps::EpVoteApp::ApplicationForm.new(step: step)
    render step
  end

  private def form_params
    params.require(:apps_ep_vote_app_application_form).permit(
      :step,
      :place,
      :citizenship,
      :delivery,
      :full_name, :pin, :nationality, :maiden_name,
      :authorized_person_full_name, :authorized_person_pin,
      :street, :pobox, :municipality,
      :same_delivery_address,
      :delivery_street, :delivery_pobox, :delivery_municipality, :delivery_country,
      :municipality_email,
      :municipality_email_verified,
      :sk_citizen_residency,
      :back,
      :eu_citizen_residency,
      :eu_citizen_sk_resident,
      :eu_citizen_non_sk_resident
    )
  end

  private def set_metadata
    @metadata.og.title = 'Žiadosť o hlasovací preukaz'
    @metadata.og.image = 'https://volby.digital/images/share-ep-2024.png'
    @metadata.og.description = 'Aj keď budete počas volieb mimo trvalého pobytu, voliť sa dá. Stačí požiadať.'
  end

  private def check_inactive_ep_application
    return if Apps::EpVoteApp::ApplicationForm.active?
    return redirect_to apps_ep_vote_app_application_forms_path if action_name != "show"
    render 'inactive'
  end
end
