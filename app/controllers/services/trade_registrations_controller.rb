class Services::TradeRegistrationsController < ApplicationController
  include Wicked::Wizard::Translated

  before_action :load_registration

  steps :personal_details, :address, :origin, :health_insurance, :trade_name, :trade_subjects, :done, :form

  def show
    if @registration.new_record?
      redirect_to wizard_path(steps.first) and return unless step == steps.first
    end

    render_wizard
  end

  def update
    @registration.progress_step = current_step
    @registration.assign_attributes(allowed_params)
    render_wizard @registration
  end

  private

  def load_registration
    @registration = Services::TradeRegistration.last || Services::TradeRegistration.new
  end

  def current_step
    wizard_value(step)&.to_sym || steps.first
  end

  def allowed_params
    params.require(:registration).permit(
      :first_name,
      :last_name,
      :birth_code,

      :street_name,
      :street_number,
      :city,
      :postcode,

      :place_of_birth,
      :father_first_name,
      :father_last_name,
      :mother_first_name,
      :mother_last_name,
      :mother_maiden_name,

      :health_insurance_company_id,

      :trade_name,

      trade_subjects_attributes: [:id, :name, :_destroy]
    )
  end
end
