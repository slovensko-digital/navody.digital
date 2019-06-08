class Apps::ChildBirthApp::PickingUpProtocolsController < ApplicationController
  layout false

  def show
    @mother_civil_state = params[:mother_civil_state].to_s.to_sym
    @born_before_300_days = params[:born_before_300_days].to_s.to_sym
    @task = Apps::ChildBirthApp::PickingUpProtocol.ask_or_answer(
      @mother_civil_state,
      @born_before_300_days
    )
  end
end
