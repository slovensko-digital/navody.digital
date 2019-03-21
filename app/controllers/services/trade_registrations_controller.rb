class Services::TradeRegistrationsController < ApplicationController
  layout 'trade_registration'
  include Wicked::Wizard::Translated

  before_action :load_registration, except: :create

  steps :personal_details, :address, :origin, :health_insurance, :trade_name,
        :trade_subjects, :done, :form

  def show
    render_wizard
  end

  def create
    user_step = current_user.user_steps.find(params[:user_step_id])
    @registration = Services::TradeRegistration.create(user_step: user_step)
    redirect_to wizard_path(steps.first)
  end

  def update
    @registration.progress_step = current_step
    @registration.assign_attributes(allowed_params)
    render_wizard @registration
  end

  private

  def load_registration
    @registration = Services::TradeRegistration.last!
  end

  def current_step
    wizard_value(step)&.to_sym || steps.first
  end

  def allowed_params
    params.require(:registration).permit(
      :user_step_id,
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
