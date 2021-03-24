class Submissions::OboTokensController < SubmissionsController
  mattr_reader :slovensko_sk_api_login_url, default: URI.join(ENV['SLOVENSKO_SK_API_URL'], 'login')
  mattr_reader :slovensko_sk_api_obo_token_public_key, default: OpenSSL::PKey::RSA.new(ENV['SLOVENSKO_SK_API_OBO_TOKEN_PUBLIC_KEY']).public_key

  def new
    obo_token_request.id = obo_token_request_id
    redirect_to slovensko_sk_api_login_url.tap { |url| url.query = URI.encode_www_form(callback: submissions_obo_token_url(id: obo_token_request.id)) }.to_s
  end

  def create
    obo_token_request.obo_token = Submissions::OboToken.parse(params.require(:token), public_key: slovensko_sk_api_obo_token_public_key)
    # TODO render js to close tab
  end

  def callback
    @token, _ = JWT.decode(params[:token], nil, false)
    render layout: false
  end

  private

  def obo_token_request_id
    params.require(:id)
  end
end
