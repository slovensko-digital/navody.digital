class OrSrRecordFetcher
  def self.get_document(cin)
    final_urls = retrieve_entity_urls(cin)

    results = final_urls.map do |url|
      resp = HTTP.get(url, encoding: 'windows-1250').to_s.encode('utf-8')
      return if resp.include?('Spis odstúpený na iný registrový súd')

      Nokogiri::HTML(resp)
    end.compact

    raise OrsrRecordError.new("No active records found for company id: #{cin}") if results.size == 0
    raise OrsrRecordError.new("Several active records found for one company id: #{cin}") if results.size > 1

    results.first
  end

  def self.get_stakeholders_identifiers_status(doc)
    stakeholders_table = nil

    doc.css('body > table').each do |table|
      if table.css('span')&.first&.inner_text&.include?('Spoločníci:')
        stakeholders_table = table
        break
      end
    end

    ok = []
    missing = []

    stakeholders_table.css('td[align=left]').last.children.each do |stakeholder_table|
      stakeholder_name = if stakeholder_table.css('.lnm').any?
                           stakeholder_table.css('.lnm').inner_text.squeeze.strip
                         else
                           stakeholder_table.css('td').first.css('span').first.inner_text.squeeze.strip
                         end

      if stakeholder_table.css('a>img').first['alt'].start_with?("Osoba nemá")
        missing << stakeholder_name
      else
        ok << stakeholder_name
      end
    end

    { ok: ok, missing: missing }
  end

  def self.get_stakeholders_deposit_entries(doc)
    stakeholders_table = nil

    doc.css('body > table').each do |table|
      if table.css('span')&.first&.inner_text&.include?('Výška vkladu každého spoločníka:')
        stakeholders_table = table
        break
      end
    end

    deposit_entries = []

    stakeholders_table.css('table').each do |stakeholder_table|
      deposit_entries << stakeholder_deposit_data(stakeholder_table)
    end

    deposit_entries
  end

  class OrsrRecordError < StandardError
  end

  private

  def self.retrieve_entity_urls(cin)
    resp = HTTP.get("https://www.orsr.sk/hladaj_ico.asp?ICO=#{cin}&SID=0", encoding: 'windows-1250').to_s.encode('utf-8')
    doc = Nokogiri::HTML(resp)
    doc.css('a[alt="Aktuálny výpis"]').map do |link_el|
      "https://www.orsr.sk/#{link_el['href']}"
    end
  end

  def self.stakeholder_deposit_data(table)
    names = []
    deposit = []

    deposits_line = false

    table.css('td').first.children.each do |node|
      deposits_line = true if node.name == 'br'

      if node.name == 'span'
        if deposits_line
          deposit << node.inner_text.strip
        else
          names << node.inner_text.strip
        end
      end
    end

    {
      'name' => names.join(' '),
      'deposit' => deposit.first.delete('Vklad: ').delete(' ').to_i,
      'deposit_currency' => deposit.second.strip,
      'paid_deposit' => deposit.third.delete('Splatené: ').delete(' ').to_i,
      'paid_deposit_currency' => deposit.fourth.strip,
    }
  end
end
