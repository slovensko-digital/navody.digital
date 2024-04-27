class AltchaController < ApplicationController
  def new
    render json: Altcha::Challenge.create.to_json
  end
end
