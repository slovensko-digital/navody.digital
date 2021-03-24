class Submissions::OboTokenRequest
  include ActiveModel::Model

  attr_accessor :id, :obo_token

  def initiated?
    id.present?
  end

  def pending?
    obo_token.nil?
  end

  alias_method :to_param, :id
end
