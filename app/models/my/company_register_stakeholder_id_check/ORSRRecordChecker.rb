require 'http'
require 'nokogiri'

module My
  module CompanyRegisterStakeholderIdCheck
    class ORSRRecordChecker
      def self.call(ico)
        final_urls = retrieve_entity_urls(ico)
        final_urls.map do |final_url|
          retrieve_record_status_info(final_url)
        end.compact
      end

      def self.retrieve_entity_urls(ico)
        resp = HTTP.get("https://www.orsr.sk/hladaj_ico.asp?ICO=#{ico}&SID=0", encoding: 'windows-1250').to_s.encode('utf-8')
        doc = Nokogiri::HTML(resp)
        doc.css('a[alt="Aktuálny výpis"]').map do |link_el|
          "https://www.orsr.sk/#{link_el['href']}"
        end
      end

      def self.retrieve_record_status_info(url)
        resp = HTTP.get(url, encoding: 'windows-1250').to_s.encode('utf-8')
        return if resp.include?('Spis odstúpený na iný registrový súd')

        doc = Nokogiri::HTML(resp)
        partners_table = nil
        doc.css('body > table').each do |table|
          if table.css('span')&.first&.inner_text&.include?('Spoločníci:')
            partners_table = table
            break
          end
        end

        ok = []
        missing = []
        partners_table.css('td[align=left]').last.children.each do |partner_table|
          partner_name = if partner_table.css('.lnm').any?
            partner_table.css('.lnm').inner_text.squeeze.strip
          else
            partner_table.css('td').first.css('span').first.inner_text.squeeze.strip
          end
          if partner_table.css('a>img').first['alt'].start_with?("Osoba nemá")
            missing << partner_name
          else
            ok << partner_name
          end
        end

        { ok: ok, missing: missing }
      end
    end
  end
end

# puts 46058397, My::CompanyRegisterStakeholderIdCheck::ORSRRecordChecker.call(46058397)
# puts 50881337, My::CompanyRegisterStakeholderIdCheck::ORSRRecordChecker.call(50881337)
# puts 45638438, My::CompanyRegisterStakeholderIdCheck::ORSRRecordChecker.call(45638438)


