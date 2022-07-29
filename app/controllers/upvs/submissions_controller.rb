class Upvs::SubmissionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:new]
  before_action :load_upvs_submission, only: [:new, :submit, :continue]

  def new
    unless @upvs_submission.valid?
      # error
    end
  end

  def login_callback
    session[:eid_encoded_token] = params[:token]
    @token = params[:token]

    render layout: false
  end

  def switch_account_callback
    session.delete(:eid_encoded_token)
    @token = nil

    render action: :login_callback, layout: false
  end

  def resubmit_without_token
    session.delete(:eid_encoded_token)

    render action: :resubmit_without_token, layout: false
  end

  def submit
    return resubmit_without_token unless @upvs_submission.token&.valid? # If token expires meanwhile

    if @upvs_submission.save
      response = submit_to_sk_api

      if successful_sk_api_submission?(response)
        if @upvs_submission.callback_url.present?
          render action: :continue
        else
          redirect_to action: :finish
        end
      else
        # TODO notify in Slack devops
        redirect_to action: :submit_error

      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def continue
  end

  def finish
  end

  def submit_error
  end

  private

  def submit_to_sk_api(client: Faraday)
    headers =  { "Content-Type": "application/json" }
    data =  { message: UpvsSubmissions::SktalkMessageBuilder.new.build_sktalk_message(@upvs_submission) }.to_json
    url = "#{ENV.fetch('SLOVENSKO_SK_API_URL')}/api/sktalk/receive_and_save_to_outbox?token=#{@upvs_submission.token.api_token}"

    client.post(url, data, headers)
  end

  def successful_sk_api_submission?(response)
    json_body = JSON.parse(response.body)

    return true if (response.status == 200 && json_body["receive_result"] == 0 && json_body["save_to_outbox_result"] == 0)
    false
  end

  def load_upvs_submission
    @upvs_submission = Upvs::Submission.new(application_params)
    @upvs_submission.token = eid_token
  end

  def application_params
    params.require(:upvs_submission).permit(
      :authenticity_token,
      :posp_id,
      :posp_version,
      :message_type,
      :recipient_uri,
      :sender_business_reference,
      :recipient_business_reference,
      :message_subject,
      :form,
      :attachments,
      :token,
      :callback_url
    ).except(:authenticity_token)
  end
end
