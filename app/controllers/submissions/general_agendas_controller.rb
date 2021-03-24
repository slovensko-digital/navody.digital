class Submissions::GeneralAgendasController < SubmissionsController
  before_action :load_general_agenda, only: [:new, :create]

  def new
  end

  def create
    if @general_agenda.expired?
      render :new
    else
      # TODO validate & call sktalk receive api
    end
  end

  def submit
    render partial: 'submit'
  end

  private

  def general_agenda_params
    params.require(:submissions_general_agenda).permit(:recipient_uri, :subject, :body, :attachments) if params.key?(:submissions_general_agenda)
  end

  def load_general_agenda
    @general_agenda = Submissions::GeneralAgenda.new(general_agenda_params)
  end

  def obo_token_request_id
    params.require(:id)
  end
end
