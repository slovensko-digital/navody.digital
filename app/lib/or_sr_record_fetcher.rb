class OrSrRecordFetcher
  def self.get_document(cin)
    final_urls = retrieve_entity_urls(cin)

    results = final_urls.map do |url|
      resp = HTTP.get(url, encoding: 'windows-1250').to_s.encode('utf-8')
      ['Spis odstúpený na iný registrový súd', 'Spoločnosť zrušená', 'Dôvod výmazu'].any? { |s| resp.include?(s) } ? nil : Nokogiri::HTML(resp)
    end.compact

    raise OrsrRecordError.new("No active records found for company id: #{cin}") if results.size == 0
    raise OrsrRecordError.new("Several active records found for one company id: #{cin}") if results.size > 1

    results.first
  end

  def self.get_stakeholders(doc)
    stakeholders_table = get_stakeholders_table(doc)
    stakeholders = []

    stakeholders_table.css('td[align=left]').last.children.each do |stakeholder_table|
      stakeholders << get_stakeholder_name(stakeholder_table)
    end

    stakeholders
  end

  def self.get_stakeholders_identifiers_status(doc)
    stakeholders_table = get_stakeholders_table(doc)

    ok = []
    missing = []

    stakeholders_table.css('td[align=left]').last.children.each do |stakeholder_table|
      stakeholder_name = get_stakeholder_name(stakeholder_table)

      if stakeholder_table.css('a>img').first['alt'].start_with?("Osoba nemá")
        missing << stakeholder_name
      else
        ok << stakeholder_name
      end
    end

    { ok: ok, missing: missing }
  end

  def self.get_stakeholders_deposit_entries(doc)
    deposits_table = get_stakeholders_table(doc, text: 'Výška vkladu každého spoločníka:')

    deposit_entries = []

    deposits_table.css('table').each do |stakeholder_table|
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
      'deposit' => deposit&.first&.delete('Vklad: ')&.delete(' ')&.to_i,
      'deposit_currency' => deposit&.second&.strip,
      'paid_deposit' => get_paid_deposit(deposit)&.delete('Splatené: ')&.delete(' ')&.to_i,
      'paid_deposit_currency' => deposit&.last&.strip,
    }
  end

  def self.get_paid_deposit(deposit)
    deposit.select{ |d| d.include? 'Splatené' }&.first
  end

  def self.get_stakeholders_table(doc, text: 'Spoločníci:')
    stakeholders_table = nil

    doc.css('body > table').each do |table|
      if table.css('span')&.first&.inner_text&.include?(text)
        stakeholders_table = table
        break
      end
    end

    stakeholders_table
  end

  def self.get_stakeholder_name(stakeholder_table)
    if stakeholder_table.css('.lnm').any?
      stakeholder_table.css('.lnm').inner_text.strip
    else
      stakeholder_table.css('td').first.css('span').first.inner_text.strip
    end
  end
end
