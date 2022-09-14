class UpvsSubmissions::OrSrFormBuilder
  class << self
    delegate :uuid, to: SecureRandom
  end

  def self.fuzs_missing_identifiers(fuzs_data)
    <<~FORM
      <?mso-infoPathSolution name="urn:schemas-microsoft-com:office:infopath:FUZS:http---www-justice-gov-sk-Forms20200821" solutionVersion="1.0.0.1133" productVersion="14.0.0.0" PIVersion="1.0.0.0" href="http://www.justice.gov.sk/FormServerTemplates/FUZS.xsn" language="sk-SK"?>
      <?mso-application progid="InfoPath.Document" versionProgid="InfoPath.Document.2"?>
      <?mso-infoPath-file-attachment-present?>
      <?xml-stylesheet type="text/xsl" href="http://eformulare.justice.sk/schemasAndTransformations/FUZS.2020.08.21.xslt" ?>
      <ns1:FUZS xsi:schemaLocation="http://www.justice.gov.sk/Forms http://eformulare.justice.sk/schemasAndTransformations/FUZS.2020.08.21.xsd"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:ns1="http://www.justice.gov.sk/Forms20200821"
        xmlns:dfs="http://schemas.microsoft.com/office/infopath/2003/dataFormSolution"
        xmlns:tns="http://www.justice.gov.sk/FormsEnums"
        xmlns:http="http://schemas.xmlsoap.org/wsdl/http/"
        xmlns:soap12="http://schemas.xmlsoap.org/wsdl/soap12/"
        xmlns:mime="http://schemas.xmlsoap.org/wsdl/mime/"
        xmlns:soapenc="http://schemas.xmlsoap.org/soap/encoding/"
        xmlns:tm="http://microsoft.com/wsdl/mime/textMatching/"
        xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
        xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
        xmlns:ns2="http://www.justice.gov.sk/FormsValidations"
        xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2010-02-24T12:58:10"
        xmlns:xd="http://schemas.microsoft.com/office/infopath/2003">
        #{form_info}
        #{registration_office(fuzs_data.court)}
        <ns1:ZapisatK xsi:nil="true"></ns1:ZapisatK>
        <ns1:PrilohyKNavrhu>
          <ns1:poradoveCislo>1</ns1:poradoveCislo>
          <ns1:Nazov>ziadne prilohy - formular je nevalidny bez uvedenia prilohy</ns1:Nazov>
        </ns1:PrilohyKNavrhu>
        <ns1:Spolocnost>#{fuzs_data.name&.encode(:xml => :text)}</ns1:Spolocnost>
        <ns1:V>Bratislave</ns1:V>
        <ns1:Dna>#{Date.today}</ns1:Dna>
        <ns1:Postou>true</ns1:Postou>
        <ns1:Osobne>false</ns1:Osobne>
        <ns1:SpisovaZnacka>
          <ns1:Oddiel>
            <ns1:Id>3</ns1:Id>
            <ns1:Value>Sro</ns1:Value>
          </ns1:Oddiel>
          <ns1:VlozkaCislo>#{fuzs_data.registration_number}</ns1:VlozkaCislo>
          <ns1:Sud>#{fuzs_data.court.code}</ns1:Sud>
        </ns1:SpisovaZnacka>
        #{claimer(fuzs_data)}
        #{COMPANY}
        #{STATUTORY_ENTRIES}
        #{stakeholder_entries(fuzs_data)}
        #{PROPERTY_INFO}
        #{FOOTER}
      </ns1:FUZS>
    FORM
  end

  private

  def self.form_info
    <<~FORM_INFO
      <ns1:IdentifikacneUdajeFormulara>
        <ns1:Nazov></ns1:Nazov>
        <ns1:IdentifikatorMFSR></ns1:IdentifikatorMFSR>
        <ns1:Verzia>1.0.0.1133</ns1:Verzia>
        <ns1:Popis xsi:nil="true"></ns1:Popis>
        <ns1:NazovGaranta></ns1:NazovGaranta>
        <ns1:PlatnostOd xsi:nil="true"></ns1:PlatnostOd>
        <ns1:PlatnostDo xsi:nil="true"></ns1:PlatnostDo>
      </ns1:IdentifikacneUdajeFormulara>
      <ns1:InfoPathData>
        <ns1:ID>#{uuid}</ns1:ID>
        <ns1:Message></ns1:Message>
        <ns1:BinaryIn xsi:nil="true"></ns1:BinaryIn>
        <ns1:BinaryOut xsi:nil="true"></ns1:BinaryOut>
        <ns1:ValidationResult>0</ns1:ValidationResult>
        <ns1:ShowWarnings>true</ns1:ShowWarnings>
      </ns1:InfoPathData>
    FORM_INFO
  end

  def self.registration_office(office)
    <<~REGISTRATION_OFFICE
      <ns1:ObchodnyRegister>
        <ns1:OkresnySud>#{office.name}</ns1:OkresnySud>
        <ns1:Ulica>#{office.street}</ns1:Ulica>
        <ns1:Cislo>#{office.number}</ns1:Cislo>
        <ns1:Obec>#{office.municipality}</ns1:Obec>
        <ns1:Psc>#{office.postal_code}</ns1:Psc>
        <ns1:Id>#{office.identifier}</ns1:Id>
        <ns1:Kod>#{office.code}</ns1:Kod>
      </ns1:ObchodnyRegister>
    REGISTRATION_OFFICE
  end

  def self.claimer(claimer)
    <<~CLAIMER
      #{CLAIMER_PERSON}
      <ns1:NavrhovatelPO>
        <ns1:ObchodneMeno>#{claimer.name&.encode(:xml => :text)}</ns1:ObchodneMeno>
        <ns1:Ico></ns1:Ico>
        <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
        #{address(claimer.address)}
      </ns1:NavrhovatelPO>
    CLAIMER
  end

  def self.stakeholder_entries(data)
    stakeholders_persons = data.stakeholders_with_missing_identifiers_persons.size > 0 ? data.stakeholders_with_missing_identifiers_persons : [nil]
    stakeholders_corporate_bodies = data.stakeholders_with_missing_identifiers_cb.size > 0 ? data.stakeholders_with_missing_identifiers_cb : [nil]

    (
      stakeholders_persons.map {|s| stakeholder_person(s) } +
      stakeholders_corporate_bodies.map {|s| stakeholder_corporate_body(s) }
    ).join("\n")
  end

  def self.stakeholder_person(stakeholder)
    <<~STAKEHOLDER
      <ns1:SpolocnikFO ns1:menit="#{(stakeholder && !stakeholder.identifier_ok) ? true : false}"#{' xmlns:ns1="http://www.justice.gov.sk/Forms20200821"' if stakeholder}>
        <ns1:Zapis>
          <ns1:Spolocnik>
            #{person(stakeholder)}
            #{address(stakeholder&.address)}
          </ns1:Spolocnik>
          #{deposit_entries(stakeholder&.deposit_entries)}
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:Spolocnik>
            #{person(stakeholder, with_identifiers: false)}
            #{address(stakeholder&.address, with_identifiers: false, with_original_municipality: true)}
          </ns1:Spolocnik>
          #{deposit_entries(stakeholder&.deposit_entries)}
        </ns1:Vymaz>
        #{backup_right(stakeholder)}
      </ns1:SpolocnikFO>
    STAKEHOLDER
  end

  def self.stakeholder_corporate_body(stakeholder)
    <<~STAKEHOLDER
      <ns1:SpolocnikPO ns1:menit="#{(stakeholder && !stakeholder.identifier_ok) ? true : false}"#{' xmlns:ns1="http://www.justice.gov.sk/Forms20200821"' if stakeholder}>
        <ns1:Zapis>
          <ns1:Spolocnik>
            <ns1:ObchodneMeno>#{stakeholder&.full_name&.encode(:xml => :text)}</ns1:ObchodneMeno>
            <ns1:Ico>#{stakeholder&.identifier}</ns1:Ico>
            <ns1:InyIdentifikacnyUdaj>#{stakeholder&.other_identifier}</ns1:InyIdentifikacnyUdaj>
             #{address(stakeholder&.address)}
          </ns1:Spolocnik>
          #{deposit_entries(stakeholder&.deposit_entries)}
        </ns1:Zapis>
        <ns1:Vymaz>
           <ns1:Spolocnik>
            <ns1:ObchodneMeno>#{stakeholder&.full_name&.encode(:xml => :text)}</ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
             #{address(stakeholder&.address, with_identifiers: false, with_original_municipality: true)}
          </ns1:Spolocnik>
          #{deposit_entries(stakeholder&.deposit_entries)}
        </ns1:Vymaz>
        #{backup_right(stakeholder)}
      </ns1:SpolocnikPO>
    STAKEHOLDER
  end

  def self.backup_right(data)
    <<~BACKUP_RIGHT
      <ns1:ZaloznePravo>
        <ns1:Zapis>
          <ns1:CisloZaloznejZmluvy></ns1:CisloZaloznejZmluvy>
          <ns1:DatumUzavretiaZaloznejZmluvy xsi:nil="true"#{' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' if data}></ns1:DatumUzavretiaZaloznejZmluvy>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:CisloZaloznejZmluvy></ns1:CisloZaloznejZmluvy>
          <ns1:DatumUzavretiaZaloznejZmluvy xsi:nil="true"#{' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' if data}></ns1:DatumUzavretiaZaloznejZmluvy>
        </ns1:Vymaz>
        <ns1:ZaloznyVeritelFO>
          <ns1:Zapis>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"#{' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' if data}></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"#{' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' if data}></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Vymaz>
        </ns1:ZaloznyVeritelFO>
        <ns1:ZaloznyVeritelPO>
          <ns1:Zapis>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Vymaz>
        </ns1:ZaloznyVeritelPO>
      </ns1:ZaloznePravo>
    BACKUP_RIGHT
  end

  def self.person(data, with_identifiers: true)
    <<~PERSON
      <ns1:Osoba>
        <ns1:TitulPred>#{data&.prefixes}</ns1:TitulPred>
        <ns1:Meno>#{data&.given_name}</ns1:Meno>
        <ns1:Priezvisko>#{data&.family_name}</ns1:Priezvisko>
        <ns1:TitulZa>#{data&.postfixes}</ns1:TitulZa>
        <ns1:DatumNarodenia #{(with_identifiers && data&.date_of_birth) ? 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' : 'xsi:nil="true"'}>#{data&.date_of_birth if with_identifiers}</ns1:DatumNarodenia>
        <ns1:RodneCislo>#{data&.identifier if with_identifiers}</ns1:RodneCislo>
        <ns1:TypInyIdentifikator>
          <ns1:Id>#{data&.other_identifier_type_data&.dig(:id) if with_identifiers}</ns1:Id>
          <ns1:Value>#{data&.other_identifier_type_data&.dig(:value) if with_identifiers}</ns1:Value>
          <ns1:Znacka>#{data&.other_identifier_type_data&.dig(:code) if with_identifiers}</ns1:Znacka>
        </ns1:TypInyIdentifikator>
        <ns1:InyIdentifikacnyUdaj>#{data&.other_identifier if with_identifiers}</ns1:InyIdentifikacnyUdaj>
      </ns1:Osoba>
    PERSON
  end

  def self.address(address, with_identifiers: true, with_original_municipality: false)
    <<~ADDRESS
      <ns1:Adresa>
        <ns1:Ulica>#{address&.street}</ns1:Ulica>
        <ns1:Cislo>#{address&.number}</ns1:Cislo>
        <ns1:Obec>
          <ns1:Id>#{address&.municipality_identifier if with_identifiers}</ns1:Id>
          <ns1:StatId></ns1:StatId>
          <ns1:Value>#{with_original_municipality ? address&.original_municipality : address&.municipality}</ns1:Value>
          <ns1:Obce></ns1:Obce>
        </ns1:Obec>
        <ns1:Psc>#{address&.postal_code}</ns1:Psc>
        <ns1:Stat>
          <ns1:Id>#{address&.country_identifier if with_identifiers}</ns1:Id>
          <ns1:Value>#{address&.country}</ns1:Value>
        </ns1:Stat>
      </ns1:Adresa>
    ADDRESS
  end

  def self.deposit_entries(entries)
    return deposit_entry(nil) unless entries

    entries.map {|entry| deposit_entry(entry) }.join("\n")
  end

  def self.deposit_entry(entry)
    <<~ENTRY
      <ns1:Vklad>
        <ns1:VyskaVkladu>
          <ns1:Suma #{entry&.deposit ? ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' : 'xsi:nil="true"'}>#{entry&.deposit}</ns1:Suma>
          #{currency(entry&.deposit_currency)}
          <ns1:TypVkladu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:TypVkladu>
        </ns1:VyskaVkladu>
        <ns1:RozsahSplatenia>
          <ns1:Suma #{entry&.paid_deposit ? ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' : 'xsi:nil="true"'}>#{entry&.paid_deposit}</ns1:Suma>
          #{currency(entry&.paid_deposit_currency)}
        </ns1:RozsahSplatenia>
      </ns1:Vklad>
    ENTRY
  end

  def self.currency(currency)
    <<~CURRENCY
      <ns1:Mena>
        <ns1:Id>#{currency.identifier if currency&.identifier}</ns1:Id>
        <ns1:Value>#{currency.value if currency&.value}</ns1:Value>
        <ns1:Znacka>#{currency.code if currency&.code}</ns1:Znacka>
      </ns1:Mena>
    CURRENCY
  end

  delegate :uuid, to: self

  COMPANY = <<~COMPANY
    <ns1:ObchodneMeno ns1:menit="false">
      <ns1:Zapis></ns1:Zapis>
      <ns1:Vymaz></ns1:Vymaz>
    </ns1:ObchodneMeno>
    <ns1:Sidlo ns1:menit="false">
      <ns1:Zapis>
        <ns1:Ulica></ns1:Ulica>
        <ns1:Cislo></ns1:Cislo>
        <ns1:Obec>
          <ns1:Id></ns1:Id>
          <ns1:StatId></ns1:StatId>
          <ns1:Value></ns1:Value>
          <ns1:Obce></ns1:Obce>
        </ns1:Obec>
        <ns1:Psc></ns1:Psc>
        <ns1:Stat>
          <ns1:Id></ns1:Id>
          <ns1:Value></ns1:Value>
        </ns1:Stat>
      </ns1:Zapis>
      <ns1:Vymaz>
        <ns1:Ulica></ns1:Ulica>
        <ns1:Cislo></ns1:Cislo>
        <ns1:Obec>
          <ns1:Id></ns1:Id>
          <ns1:StatId></ns1:StatId>
          <ns1:Value></ns1:Value>
          <ns1:Obce></ns1:Obce>
        </ns1:Obec>
        <ns1:Psc></ns1:Psc>
        <ns1:Stat>
          <ns1:Id></ns1:Id>
          <ns1:Value></ns1:Value>
        </ns1:Stat>
      </ns1:Vymaz>
    </ns1:Sidlo>
    <ns1:Ico ns1:menit="false">
      <ns1:Zapis></ns1:Zapis>
      <ns1:Vymaz></ns1:Vymaz>
    </ns1:Ico>
    <ns1:PravnaForma ns1:menit="false">
      <ns1:Zapis>
        <ns1:Id></ns1:Id>
        <ns1:Value></ns1:Value>
      </ns1:Zapis>
      <ns1:Vymaz>
        <ns1:Id></ns1:Id>
        <ns1:Value></ns1:Value>
      </ns1:Vymaz>
    </ns1:PravnaForma>
    <ns1:PredmetPodnikania ns1:menit="false">
      <ns1:Zapis>
        <ns1:PoradoveCislo></ns1:PoradoveCislo>
        <ns1:Cinnost></ns1:Cinnost>
      </ns1:Zapis>
      <ns1:Vymaz>
        <ns1:PoradoveCislo></ns1:PoradoveCislo>
        <ns1:Cinnost></ns1:Cinnost>
      </ns1:Vymaz>
    </ns1:PredmetPodnikania>
  COMPANY

  CLAIMER_PERSON = <<~CLAIMER
      <ns1:NavrhovatelFO>
        <ns1:Osoba>
          <ns1:TitulPred></ns1:TitulPred>
          <ns1:Meno></ns1:Meno>
          <ns1:Priezvisko></ns1:Priezvisko>
          <ns1:TitulZa></ns1:TitulZa>
          <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
          <ns1:RodneCislo></ns1:RodneCislo>
          <ns1:TypInyIdentifikator>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
            <ns1:Znacka></ns1:Znacka>
          </ns1:TypInyIdentifikator>
          <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
        </ns1:Osoba>
        <ns1:Adresa>
          <ns1:Ulica></ns1:Ulica>
          <ns1:Cislo></ns1:Cislo>
          <ns1:Obec>
            <ns1:Id></ns1:Id>
            <ns1:StatId></ns1:StatId>
            <ns1:Value></ns1:Value>
            <ns1:Obce></ns1:Obce>
          </ns1:Obec>
          <ns1:Psc></ns1:Psc>
          <ns1:Stat>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:Stat>
        </ns1:Adresa>
      </ns1:NavrhovatelFO>
    CLAIMER

  STATUTORY_ENTRIES = <<~STATUTORY_ENTRIES
      <ns1:StatutarnyOrganFO ns1:menit="false">
        <ns1:Zapis>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Vymaz>
      </ns1:StatutarnyOrganFO>
      <ns1:StatutarnyOrganSposobKonania ns1:menit="false">
        <ns1:Zapis></ns1:Zapis>
        <ns1:Vymaz></ns1:Vymaz>
      </ns1:StatutarnyOrganSposobKonania>
      <ns1:OrganizacnaZlozka ns1:menit="false">
        <ns1:OrganizacnaZlozka>
          <ns1:Zapis>
            <ns1:Oznacenie></ns1:Oznacenie>
            <ns1:AdresaUmiestnenia>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:AdresaUmiestnenia>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:Oznacenie></ns1:Oznacenie>
            <ns1:AdresaUmiestnenia>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:AdresaUmiestnenia>
          </ns1:Vymaz>
          <ns1:Veduci>
            <ns1:Zapis>
              <ns1:FunkciaClenaStatutarnehoOrganu>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:FunkciaClenaStatutarnehoOrganu>
              <ns1:Funkcia></ns1:Funkcia>
              <ns1:Osoba>
                <ns1:TitulPred></ns1:TitulPred>
                <ns1:Meno></ns1:Meno>
                <ns1:Priezvisko></ns1:Priezvisko>
                <ns1:TitulZa></ns1:TitulZa>
                <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
                <ns1:RodneCislo></ns1:RodneCislo>
                <ns1:TypInyIdentifikator>
                  <ns1:Id></ns1:Id>
                  <ns1:Value></ns1:Value>
                  <ns1:Znacka></ns1:Znacka>
                </ns1:TypInyIdentifikator>
                <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
              </ns1:Osoba>
              <ns1:Bydlisko>
                <ns1:Ulica></ns1:Ulica>
                <ns1:Cislo></ns1:Cislo>
                <ns1:Obec>
                  <ns1:Id></ns1:Id>
                  <ns1:StatId></ns1:StatId>
                  <ns1:Value></ns1:Value>
                  <ns1:Obce></ns1:Obce>
                </ns1:Obec>
                <ns1:Psc></ns1:Psc>
                <ns1:Stat>
                  <ns1:Id></ns1:Id>
                  <ns1:Value></ns1:Value>
                </ns1:Stat>
              </ns1:Bydlisko>
              <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
              <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
            </ns1:Zapis>
            <ns1:Vymaz>
              <ns1:FunkciaClenaStatutarnehoOrganu>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:FunkciaClenaStatutarnehoOrganu>
              <ns1:Funkcia></ns1:Funkcia>
              <ns1:Osoba>
                <ns1:TitulPred></ns1:TitulPred>
                <ns1:Meno></ns1:Meno>
                <ns1:Priezvisko></ns1:Priezvisko>
                <ns1:TitulZa></ns1:TitulZa>
                <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
                <ns1:RodneCislo></ns1:RodneCislo>
                <ns1:TypInyIdentifikator>
                  <ns1:Id></ns1:Id>
                  <ns1:Value></ns1:Value>
                  <ns1:Znacka></ns1:Znacka>
                </ns1:TypInyIdentifikator>
                <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
              </ns1:Osoba>
              <ns1:Bydlisko>
                <ns1:Ulica></ns1:Ulica>
                <ns1:Cislo></ns1:Cislo>
                <ns1:Obec>
                  <ns1:Id></ns1:Id>
                  <ns1:StatId></ns1:StatId>
                  <ns1:Value></ns1:Value>
                  <ns1:Obce></ns1:Obce>
                </ns1:Obec>
                <ns1:Psc></ns1:Psc>
                <ns1:Stat>
                  <ns1:Id></ns1:Id>
                  <ns1:Value></ns1:Value>
                </ns1:Stat>
              </ns1:Bydlisko>
              <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
              <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
            </ns1:Vymaz>
          </ns1:Veduci>
          <ns1:PredmetPodnikania>
            <ns1:Zapis>
              <ns1:PoradoveCislo></ns1:PoradoveCislo>
              <ns1:Cinnost></ns1:Cinnost>
            </ns1:Zapis>
            <ns1:Vymaz>
              <ns1:PoradoveCislo></ns1:PoradoveCislo>
              <ns1:Cinnost></ns1:Cinnost>
            </ns1:Vymaz>
          </ns1:PredmetPodnikania>
        </ns1:OrganizacnaZlozka>
      </ns1:OrganizacnaZlozka>
      <ns1:Prokurista ns1:menit="false">
        <ns1:Zapis>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Vymaz>
      </ns1:Prokurista>
      <ns1:ProkuraSposobKonania ns1:menit="false">
        <ns1:Zapis></ns1:Zapis>
        <ns1:Vymaz></ns1:Vymaz>
      </ns1:ProkuraSposobKonania>
  STATUTORY_ENTRIES

  PROPERTY_INFO = <<~PROPERTY_ENTRIES
      <ns1:Spoluvlastnictvo ns1:menit="false">
        <ns1:SpolocnyObchodnyPodiel>
          <ns1:Zapis>
            <ns1:VyskaVkladu>
              <ns1:Suma xsi:nil="true"></ns1:Suma>
              <ns1:Mena>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:Mena>
              <ns1:TypVkladu>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:TypVkladu>
            </ns1:VyskaVkladu>
            <ns1:RozsahSplatenia>
              <ns1:Suma xsi:nil="true"></ns1:Suma>
              <ns1:Mena>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:Mena>
            </ns1:RozsahSplatenia>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:VyskaVkladu>
              <ns1:Suma xsi:nil="true"></ns1:Suma>
              <ns1:Mena>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:Mena>
              <ns1:TypVkladu>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:TypVkladu>
            </ns1:VyskaVkladu>
            <ns1:RozsahSplatenia>
              <ns1:Suma xsi:nil="true"></ns1:Suma>
              <ns1:Mena>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:Mena>
            </ns1:RozsahSplatenia>
          </ns1:Vymaz>
        </ns1:SpolocnyObchodnyPodiel>
        <ns1:SpolocnyZastupcaFO>
          <ns1:Zapis>
            <ns1:Osoba>
              <ns1:TitulPred></ns1:TitulPred>
              <ns1:Meno></ns1:Meno>
              <ns1:Priezvisko></ns1:Priezvisko>
              <ns1:TitulZa></ns1:TitulZa>
              <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
              <ns1:RodneCislo></ns1:RodneCislo>
              <ns1:TypInyIdentifikator>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:TypInyIdentifikator>
              <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            </ns1:Osoba>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:Osoba>
              <ns1:TitulPred></ns1:TitulPred>
              <ns1:Meno></ns1:Meno>
              <ns1:Priezvisko></ns1:Priezvisko>
              <ns1:TitulZa></ns1:TitulZa>
              <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
              <ns1:RodneCislo></ns1:RodneCislo>
              <ns1:TypInyIdentifikator>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:TypInyIdentifikator>
              <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            </ns1:Osoba>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Vymaz>
        </ns1:SpolocnyZastupcaFO>
        <ns1:SpolocnyZastupcaPO>
          <ns1:Zapis>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Vymaz>
        </ns1:SpolocnyZastupcaPO>
        <ns1:SpoluvlastnikFO>
          <ns1:Zapis>
            <ns1:Osoba>
              <ns1:TitulPred></ns1:TitulPred>
              <ns1:Meno></ns1:Meno>
              <ns1:Priezvisko></ns1:Priezvisko>
              <ns1:TitulZa></ns1:TitulZa>
              <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
              <ns1:RodneCislo></ns1:RodneCislo>
              <ns1:TypInyIdentifikator>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:TypInyIdentifikator>
              <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            </ns1:Osoba>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:Osoba>
              <ns1:TitulPred></ns1:TitulPred>
              <ns1:Meno></ns1:Meno>
              <ns1:Priezvisko></ns1:Priezvisko>
              <ns1:TitulZa></ns1:TitulZa>
              <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
              <ns1:RodneCislo></ns1:RodneCislo>
              <ns1:TypInyIdentifikator>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:TypInyIdentifikator>
              <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            </ns1:Osoba>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Vymaz>
        </ns1:SpoluvlastnikFO>
        <ns1:SpoluvlastnikPO>
          <ns1:Zapis>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Zapis>
          <ns1:Vymaz>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Vymaz>
        </ns1:SpoluvlastnikPO>
      </ns1:Spoluvlastnictvo>
      <ns1:DozornaRada ns1:menit="false">
        <ns1:Zapis>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Vymaz>
      </ns1:DozornaRada>
      <ns1:ZakladneImanie ns1:menit="false">
        <ns1:Zapis>
          <ns1:Suma xsi:nil="true"></ns1:Suma>
          <ns1:Mena>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
            <ns1:Znacka></ns1:Znacka>
          </ns1:Mena>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:Suma xsi:nil="true"></ns1:Suma>
          <ns1:Mena>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
            <ns1:Znacka></ns1:Znacka>
          </ns1:Mena>
        </ns1:Vymaz>
      </ns1:ZakladneImanie>
      <ns1:RozsahSplatenia ns1:menit="false">
        <ns1:Zapis>
          <ns1:Suma xsi:nil="true"></ns1:Suma>
          <ns1:Mena>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
            <ns1:Znacka></ns1:Znacka>
          </ns1:Mena>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:Suma xsi:nil="true"></ns1:Suma>
          <ns1:Mena>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
            <ns1:Znacka></ns1:Znacka>
          </ns1:Mena>
        </ns1:Vymaz>
      </ns1:RozsahSplatenia>
      <ns1:Likvidacia ns1:menit="false">
        <ns1:Zapis>
          <ns1:VstupDatum xsi:nil="true"></ns1:VstupDatum>
          <ns1:VstupPopis></ns1:VstupPopis>
          <ns1:SkoncenieDatum xsi:nil="true"></ns1:SkoncenieDatum>
          <ns1:SkonceniePopis></ns1:SkonceniePopis>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:VstupDatum xsi:nil="true"></ns1:VstupDatum>
          <ns1:VstupPopis></ns1:VstupPopis>
          <ns1:SkoncenieDatum xsi:nil="true"></ns1:SkoncenieDatum>
          <ns1:SkonceniePopis></ns1:SkonceniePopis>
        </ns1:Vymaz>
      </ns1:Likvidacia>
      <ns1:LikvidatorFO ns1:menit="false">
        <ns1:Zapis>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Id></ns1:Id>
            <ns1:Value></ns1:Value>
          </ns1:FunkciaClenaStatutarnehoOrganu>
          <ns1:Funkcia></ns1:Funkcia>
          <ns1:Osoba>
            <ns1:TitulPred></ns1:TitulPred>
            <ns1:Meno></ns1:Meno>
            <ns1:Priezvisko></ns1:Priezvisko>
            <ns1:TitulZa></ns1:TitulZa>
            <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
            <ns1:RodneCislo></ns1:RodneCislo>
            <ns1:TypInyIdentifikator>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
              <ns1:Znacka></ns1:Znacka>
            </ns1:TypInyIdentifikator>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          </ns1:Osoba>
          <ns1:Bydlisko>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Bydlisko>
          <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
          <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
        </ns1:Vymaz>
      </ns1:LikvidatorFO>
      <ns1:LikvidatorPO ns1:menit="false">
        <ns1:Zapis>
          <ns1:Likvidator>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Likvidator>
          <ns1:FyzickaOsoba>
            <ns1:FunkciaClenaStatutarnehoOrganu>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Funkcia></ns1:Funkcia>
            <ns1:Osoba>
              <ns1:TitulPred></ns1:TitulPred>
              <ns1:Meno></ns1:Meno>
              <ns1:Priezvisko></ns1:Priezvisko>
              <ns1:TitulZa></ns1:TitulZa>
              <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
              <ns1:RodneCislo></ns1:RodneCislo>
              <ns1:TypInyIdentifikator>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:TypInyIdentifikator>
              <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            </ns1:Osoba>
            <ns1:Bydlisko>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Bydlisko>
            <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
            <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
          </ns1:FyzickaOsoba>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:Likvidator>
            <ns1:ObchodneMeno></ns1:ObchodneMeno>
            <ns1:Ico></ns1:Ico>
            <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            <ns1:Adresa>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Adresa>
          </ns1:Likvidator>
          <ns1:FyzickaOsoba>
            <ns1:FunkciaClenaStatutarnehoOrganu>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:FunkciaClenaStatutarnehoOrganu>
            <ns1:Funkcia></ns1:Funkcia>
            <ns1:Osoba>
              <ns1:TitulPred></ns1:TitulPred>
              <ns1:Meno></ns1:Meno>
              <ns1:Priezvisko></ns1:Priezvisko>
              <ns1:TitulZa></ns1:TitulZa>
              <ns1:DatumNarodenia xsi:nil="true"></ns1:DatumNarodenia>
              <ns1:RodneCislo></ns1:RodneCislo>
              <ns1:TypInyIdentifikator>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
                <ns1:Znacka></ns1:Znacka>
              </ns1:TypInyIdentifikator>
              <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
            </ns1:Osoba>
            <ns1:Bydlisko>
              <ns1:Ulica></ns1:Ulica>
              <ns1:Cislo></ns1:Cislo>
              <ns1:Obec>
                <ns1:Id></ns1:Id>
                <ns1:StatId></ns1:StatId>
                <ns1:Value></ns1:Value>
                <ns1:Obce></ns1:Obce>
              </ns1:Obec>
              <ns1:Psc></ns1:Psc>
              <ns1:Stat>
                <ns1:Id></ns1:Id>
                <ns1:Value></ns1:Value>
              </ns1:Stat>
            </ns1:Bydlisko>
            <ns1:DenVznikuFunkcie xsi:nil="true"></ns1:DenVznikuFunkcie>
            <ns1:DenSkonceniaFunkcie xsi:nil="true"></ns1:DenSkonceniaFunkcie>
          </ns1:FyzickaOsoba>
        </ns1:Vymaz>
      </ns1:LikvidatorPO>
      <ns1:LikvidaciaSposobKonania ns1:menit="false">
        <ns1:Zapis></ns1:Zapis>
        <ns1:Vymaz></ns1:Vymaz>
      </ns1:LikvidaciaSposobKonania>
      <ns1:SplynutieEnum>None</ns1:SplynutieEnum>
      <ns1:SplynutiePO ns1:menit="false">
        <ns1:Zapis slovZahrEnum="None">
          <ns1:ObchodneMeno></ns1:ObchodneMeno>
          <ns1:Ico></ns1:Ico>
          <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          <ns1:Adresa>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Adresa>
        </ns1:Zapis>
        <ns1:Vymaz slovZahrEnum="None">
          <ns1:ObchodneMeno></ns1:ObchodneMeno>
          <ns1:Ico></ns1:Ico>
          <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          <ns1:Adresa>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Adresa>
        </ns1:Vymaz>
      </ns1:SplynutiePO>
      <ns1:OdovzdavtelImaniaPO ns1:menit="false">
        <ns1:Zapis>
          <ns1:ObchodneMeno></ns1:ObchodneMeno>
          <ns1:Ico></ns1:Ico>
          <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          <ns1:Adresa>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Adresa>
        </ns1:Zapis>
        <ns1:Vymaz>
          <ns1:ObchodneMeno></ns1:ObchodneMeno>
          <ns1:Ico></ns1:Ico>
          <ns1:InyIdentifikacnyUdaj></ns1:InyIdentifikacnyUdaj>
          <ns1:Adresa>
            <ns1:Ulica></ns1:Ulica>
            <ns1:Cislo></ns1:Cislo>
            <ns1:Obec>
              <ns1:Id></ns1:Id>
              <ns1:StatId></ns1:StatId>
              <ns1:Value></ns1:Value>
              <ns1:Obce></ns1:Obce>
            </ns1:Obec>
            <ns1:Psc></ns1:Psc>
            <ns1:Stat>
              <ns1:Id></ns1:Id>
              <ns1:Value></ns1:Value>
            </ns1:Stat>
          </ns1:Adresa>
        </ns1:Vymaz>
      </ns1:OdovzdavtelImaniaPO>
      <ns1:Predaj ns1:menit="false">
        <ns1:Zapis></ns1:Zapis>
        <ns1:Vymaz></ns1:Vymaz>
        <ns1:CastiPodniku xsi:nil="true"></ns1:CastiPodniku>
      </ns1:Predaj>
    PROPERTY_ENTRIES

  FOOTER = <<~FORM_FOOTER
    <ns1:InePravneSkutocnosti ns1:menit="false">
      <ns1:Zapis></ns1:Zapis>
      <ns1:Vymaz></ns1:Vymaz>
    </ns1:InePravneSkutocnosti>
    <ns1:Podpis>
      <ns1:TitulPred></ns1:TitulPred>
      <ns1:Meno></ns1:Meno>
      <ns1:Priezvisko></ns1:Priezvisko>
      <ns1:TitulZa></ns1:TitulZa>
    </ns1:Podpis>
    <ns1:DobaUrcita ns1:menit="false">
      <ns1:Zapis>
        <ns1:Datum xsi:nil="true"></ns1:Datum>
        <ns1:JeDobaUrcita>false</ns1:JeDobaUrcita>
      </ns1:Zapis>
      <ns1:Vymaz>
        <ns1:Datum xsi:nil="true"></ns1:Datum>
        <ns1:JeDobaUrcita>false</ns1:JeDobaUrcita>
      </ns1:Vymaz>
    </ns1:DobaUrcita>
  FORM_FOOTER
end
