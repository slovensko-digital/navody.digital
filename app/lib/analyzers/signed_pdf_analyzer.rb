module Analyzers
  class SignedPdfAnalyzer < ActiveStorage::Analyzer
    def self.accept?(blob)
      ['application/pdf'].include? blob.content_type
    end

    def metadata
      { is_signed: is_signed? }
    end

    def is_signed?
      reader = PDF::Reader.new(blob.file)
      reader.objects.to_a.flatten.select { |o| o.is_a?(Hash) }.select { |o| o[:Type] == :Sig }.first.present?
    end
  end
end
