class SubmissionsController < ApplicationController
  protected

  def obo_token
    obo_token_request.obo_token
  end

  helper_method :obo_token

  def obo_token_request
    # TODO this assignment does not work
    # does render_async somehow mess with this?
    # can we assign ActiveModel object to session?
    session[obo_token_request_key] ||= Submissions::OboTokenRequest.new
  end

  helper_method :obo_token_request

  def obo_token_request_id
    raise NotImplementedError
  end

  helper_method :obo_token_request_id

  private

  def obo_token_request_key
    "obo_token_request_#{obo_token_request_id.presence || raise('No OBO token id')}"
  end
end
