class Upvs::SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:new]
  before_action :load_upvs_submission, only: [:new, :sign, :create, :submit, :continue]

  def new
  end

  def create
    unless @upvs_submission.valid?
      render :new, status: :unprocessable_entity
    end
  end

  def finish
  end

  def login_callback
    session[:eid_token] = params[:token]
    @token = params[:token]

    render layout: false # TODO show something nice
  end

  def switch_account_callback
    session.delete(:eid_token)
    @token = nil
    render action: :login_callback, layout: false # TODO run logout/login flow
  end

  def submit
    if @upvs_submission.save
      submit_to_sk_api

      if @upvs_submission.callback_url.present?
        render action: :continue
      else
        redirect_to action: :finish
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def submit_to_sk_api
    @token = session[:eid_token]

    sktalk_message = UpvsSubmissions::SktalkMessageBuilder.new.build_sktalk_message(@upvs_submission)

    headers =  {
      "Content-Type": "application/json"
    }

    data =  {
      message: sktalk_message
    }.to_json

    # TODO get API+OBO token
    url = "#{ENV.fetch('SLOVENSKO_SK_API_URL')}/api/sktalk/receive_and_save_to_outbox?token=#{api_token(@token)}"

    Faraday.post(url, data, headers)
  end

  def api_token(obo_token, expires_in: 4.minutes.from_now.to_i)
    JWT.encode({exp: (Time.zone.now + expires_in).to_i, jti: SecureRandom.uuid, obo: obo_token}, private_key, 'RS256', { cty: 'JWT' })
  end

  def load_upvs_submission
    @upvs_submission = Upvs::Submission.new(application_params)
  end

  def application_params
    params.require(:upvs_submission).permit(
      :posp_id,
      :posp_version,
      :message_type,
      :recipient_uri,
      :sender_business_reference,
      :recipient_business_reference,
      :message_subject,
      :form,
      :attachments
    ) if params.key?(:upvs_submission)
  end
end
