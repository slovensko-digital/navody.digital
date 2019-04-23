class Apps::EpVoteApp::ApplicationFormsController < ApplicationController
  def show
    @application_form = Apps::EpVoteApp::ApplicationForm.new(
      step: 'start'
    )
    render 'start'
  end

  def create
    @application_form = Apps::EpVoteApp::ApplicationForm.new(form_params)
    @application_form.run(self)
  end

  def end
  end

  private

  def form_params
    params.require(:apps_ep_vote_app_application_form).permit(
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
end
