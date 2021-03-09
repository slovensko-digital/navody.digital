class ExternalLinkTask < Task
  validates :url, url: true

  def self.model_name
    superclass.model_name
  end
end
