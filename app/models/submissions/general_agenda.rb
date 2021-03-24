class Submissions::GeneralAgenda
  include ActiveModel::Model

  attr_accessor :uuid
  attr_accessor :recipient_uri
  attr_accessor :subject
  attr_accessor :body
  attr_accessor :attachments

  validates_presence_of :recipient_uri, message: 'Vyplňte príjemcu podania'
  validates_presence_of :subject, message: 'Vyplňte predmet podania'
  validates_presence_of :body, message: 'Vyplňte obsah podania'

  def uuid
    @uuid ||= SecureRandom.uuid
  end

  alias_method :to_param, :uuid
end
