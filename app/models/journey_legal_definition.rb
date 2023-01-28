class JourneyLegalDefinition < ApplicationRecord
  belongs_to :journey
  belongs_to :law

  before_validation :ensure_law_exists

  def ensure_law_exists
    begin
      law_identifier = Legal::SlovLexLink.new(link).current_date_version()
      if Legal::SlovLexHelper.is_valid_law_identifier?(law_identifier)
        self.law = Law.find_or_create_by!(identifier: law_identifier)
      end
    rescue Legal::SlovLexLink::SlovLexLinkException
    end
  end
end
