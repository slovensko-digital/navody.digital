class Submission
  include ActiveModel::Model

  attr_reader :email, :email_subject, :email_body, :attachment, :subscription_types

  validates :email, presence: true

  def initialize(data)
    @email = data.fetch(:email)
  end

  # def self.from_params(params)
  #   required_keys =
  # end


end