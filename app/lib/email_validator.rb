class EmailValidator
  include ActiveModel::Validations

  attr_reader :email

  def initialize(email)
    @email = email
  end

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
