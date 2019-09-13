class Apps::ParliamentVoteApp::ApplicationFormsController < ApplicationController
  before_action :set_metadata, :check_inactive_parliament_application

  def show
    @metadata.og.title = 'Parlamentne Voľby'
    @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(step: 'start')
    render 'start'
  end

  def delivery
    if request.post?
      @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(form_params)
      @application_form.run(self)
    else
      @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(step: 'delivery')
      render 'delivery'
    end
  end

  def create
    @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(form_params)
    @application_form.run(self)
  end

  private def form_params
    params.require(:apps_parliament_vote_app_application_form).permit(
      :step,
      :place,
      :sk_citizen,
      :delivery,
      :full_name, :pin, :nationality,
      :street, :pobox, :municipality,
      :same_delivery_address,
      :delivery_street, :delivery_pobox, :delivery_municipality, :delivery_country,
      :municipality_email
    )
  end

  private def set_metadata
    @metadata.og.image = 'og-navody.png'
    @metadata.og.description = 'Zistite kde a ako môžete voliť. Vybavte si hlasovací preukaz.'
  end

  private def check_inactive_parliament_application
    return if Apps::ParliamentVoteApp::ApplicationForm.active?
    return redirect_to apps_parliament_vote_app_application_forms_path if action_name != "show"
    render 'inactive'
  end
end
