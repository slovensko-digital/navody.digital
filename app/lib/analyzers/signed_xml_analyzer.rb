module Analyzers
  class SignedXmlAnalyzer < ActiveStorage::Analyzer
    def self.accept?(blob)
      ['text/xml', 'application/xml'].include? blob.content_type
    end

    def metadata
      { is_signed: is_signed? }
    end

    def is_signed?
      # TODO
    end
  end
end
