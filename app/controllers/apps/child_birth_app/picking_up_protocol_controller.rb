class Apps::ChildBirthApp::PickingUpProtocolController < ApplicationController
  before_action :load_params, :set_app_id
  layout 'embedded_app'

  def show
    respond_to :js, :html

    return render action: :result if all_questions_answered?
    return render action: :ask_divorced if @mother_civil_state === :divorced
    return render action: :ask_widow if @mother_civil_state === :widow

    render action: :start
  end

  def start
  end

  def result
  end

  def ask_divorced
  end

  def ask_widow
  end

  private

  def all_questions_answered?
    if [:married, :single].include? @mother_civil_state
      return true
    end

    if [:divorced, :widow].include?(@mother_civil_state) && [:yes, :no].include?(@born_before_300_days)
      return true
    end
  end

  def load_params
    @mother_civil_state = params[:mother_civil_state]&.to_sym
    @born_before_300_days = params[:born_before_300_days]&.to_sym
  end

  def set_app_id
    @app_id = 'narodenie-rodny-list'
  end
end
