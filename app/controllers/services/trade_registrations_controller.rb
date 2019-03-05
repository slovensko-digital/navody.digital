class Services::TradeRegistrationsController < ApplicationController
  include Wicked::Wizard::Translated

  steps :personal_details, :address, :done

  def show
    @registration = Services::TradeRegistration.new
    render_wizard
  end

  def update
    puts params
    if current_step == :personal_details
      @registration = Services::TradeRegistration.new
    end

    @registration.assign_attributes(allowed_params)
    render_wizard @registration
  end

  private

  def current_step
    wizard_value(step).to_sym
  end

  def allowed_params
    params.require(:registration).permit(:first_name, :last_name, :birth_code)
  end
end
