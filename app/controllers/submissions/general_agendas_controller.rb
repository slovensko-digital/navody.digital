class Submissions::GeneralAgendasController < ApplicationController
  before_action :load_general_agenda, only: [:new, :create, :continue]

  def new
  end

  def create
    if @general_agenda.save
      if @general_agenda.callback_url.present?
        render action: :continue
      else
        redirect_to action: :finish
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def continue
    redirect_to @general_agenda.callback_url
  end

  def finish
  end

  def login_callback
    session[:eid_token] = params[:token]
    @general_agenda = Submissions::GeneralAgenda.new
    @general_agenda.token = params[:token]

    render layout: false # TODO show something nice
  end

  def switch_account_callback
    session.delete(:eid_token)
    @general_agenda = Submissions::GeneralAgenda.new
    render action: :login_callback, layout: false # TODO run logout/login flow
  end

  private

  def load_general_agenda
    @general_agenda = Submissions::GeneralAgenda.new(general_agenda_params)
    @general_agenda.token = session[:eid_token] if @general_agenda.token.blank? && session[:eid_token]
  end

  def general_agenda_params
    params.require(:submissions_general_agenda).permit(:recipient_uri, :subject, :body, :attachments, :token) if params.key?(:submissions_general_agenda)
  end
end
