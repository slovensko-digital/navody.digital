module Legal
  class SlovLexLink
    attr_reader :law, :version_date, :section, :given

    class SlovLexLinkException < StandardError;end

    def initialize(given_url)
      @given = given_url
      parsed = parse_given_link(given_url)

      @law = parsed[:law]
      @version_date = parsed[:version_date]
      @section = parsed[:section]
    end

    def current_date_version(with_section: false)
      link = "#{legal_link_prefix}#{@law}/"
      if with_section && @section
        "#{link}##{@section}"
      else
        link
      end
    end

    def date_version(date_string:, with_section: false)
      link = "#{legal_link_prefix}#{@law}/#{date_string}.html"

      if with_section && @section
        "#{link}##{@section}"
      else
        link
      end
    end

    private

    def parse_given_link(given_url)
      prefix = Regexp.escape(legal_link_prefix).gsub("/", "\\/")

      results = {}

      results[:law] = given_url.match(/#{prefix}(\d{4}\/\d+)/).to_a[1]

      if results[:law].nil?
        raise SlovLexLinkException, 'invalid slov-lex.sk url, no law was found (e.g. 2003/595)'
      end

      results[:version_date] = given_url.match(/#{prefix}\d{4}\/\d+\/(\d{8})/).to_a[1]

      results[:section] = given_url.match(/#{prefix}\d{4}\/.*#(.*)/).to_a[1]

      results
    end

    def legal_link_prefix
      "https://www.slov-lex.sk/pravne-predpisy/SK/ZZ/"
    end
  end
end
