class Settings
  def self.stemmer
    @@stemmer ||= Stemmer.new(Rails.root + 'dictionaries', 'sk_SK-ascii')
  end
end