class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token, raise: false

  def upload_data
    token = params[:token]
    payload = params[:payload]&.read
    data = params[:data]&.read

    dr = DataReceipt.find_by_token(token)
    if dr
      dr.received_payload = payload
      dr.received_data = data
      dr.save!
      redirect_to :root
    else
      render json: {}, status: 404, content_type: 'application/json'
    end
  end
end
