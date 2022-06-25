require 'http'
require 'nokogiri'

class ORSRRecordChecker
  def self.call(ico)
    final_url = retrieve_entity_url(ico)
    check_record(final_url)
  end

  def self.retrieve_entity_url(ico)
    resp = HTTP.get("https://www.orsr.sk/hladaj_ico.asp?ICO=#{ico}&SID=0").to_s
    doc = Nokogiri::HTML(resp)
    link_el = doc.css('a[alt="Aktuálny výpis"]')&.first
    "https://www.orsr.sk/#{link_el['href']}" if link_el
  end

  def self.check_record(url)
    resp = HTTP.get(url).to_s
    doc = Nokogiri::HTML(resp)
    
  end
end

puts ORSRRecordChecker.call(46058397)
puts ORSRRecordChecker.call('asdasd')

