class Apps::ParliamentVoteApp::ApplicationFormsController < ApplicationController
  before_action :set_metadata, :check_inactive_parliament_application

  def show
    @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(step: 'start')
    render 'start'
  end

  def delivery
    render_step 'delivery'
  end

  def world
    render_step 'world'
  end

  def world_sk_resident_form
    @data = form_params
    respond_to do |format|
      format.pdf do
        render pdf: 'ziadost-o-volbu-postou-zo-zahranicia',
              template: 'apps/parliament_vote_app/application_forms/_sk_resident_form.pdf.erb',
              encoding: "UTF-8",
              disposition: 'attachment'
      end
    end
  end

  def world_abroad_resident_form
    @data = form_params
    respond_to do |format|
      format.pdf do
        render pdf: 'ziadost-o-volbu-postou-zo-zahranicia',
              template: 'apps/parliament_vote_app/application_forms/_abroad_resident_form.pdf.erb',
              encoding: "UTF-8",
              disposition: 'attachment'
      end
    end
  end

  def world_abroad_resident_declaration
    respond_to do |format|
      format.pdf do
        render pdf: 'cestne-prehlasenie-o-trvalom-pobyte-mimo-uzemia-slovenskej-republiky',
              template: 'apps/parliament_vote_app/application_forms/_non_resident_declaration.pdf.erb',
              encoding: "UTF-8",
              disposition: 'attachment'
      end
    end
  end

  def create
    @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(form_params)
    @application_form.run(self)
  end

  private def render_step(step)
    if request.post?
      @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(form_params)
      @application_form.run(self)
    else
      @application_form = Apps::ParliamentVoteApp::ApplicationForm.new(step: step)
      render step
    end
  end

  private def form_params
    params.require(:apps_parliament_vote_app_application_form).permit(
      :step,
      :place,
      :sk_citizen,
      :delivery,
      :name, :surname, :pin, :nationality, :maiden_name,
      :street, :house_number, :pobox, :municipality,
      :same_delivery_address,
      :delivery_street, :delivery_house_number, :delivery_pobox, :delivery_municipality, :delivery_country,
      :municipality_email,
      :permanent_resident
    )
  end

  private def set_metadata
    @metadata.og.title = 'Parlamentné voľby'
    @metadata.og.image = 'og-navody.png'
    @metadata.og.description = 'Zistite kde a ako môžete voliť. Vybavte si hlasovací preukaz.'
  end

  private def check_inactive_parliament_application
    return if Apps::ParliamentVoteApp::ApplicationForm.active?
    return redirect_to apps_parliament_vote_app_application_forms_path if action_name != "show"
    render 'inactive'
  end
end
