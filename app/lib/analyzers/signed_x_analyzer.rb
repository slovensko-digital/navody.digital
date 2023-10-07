module Analyzers
  class SignedXAnalyzer < ActiveStorage::Analyzer
    def self.accept?(blob)
      ['application/vnd.etsi.asic-e+zip'].include? blob.content_type
    end

    def metadata
      { is_signed: is_signed? }
    end

    def is_signed?
      true # NOTE: this content type is always signed
    end
  end
end
