Page.find_or_create_by!(
  title: 'Kontaktné informácie',
  content: 'Tu raz urcite budu nejake informacie o tom, ako kontaktovat ludi, ktori su za touto strankou',
  slug: 'kontakt',
  is_faq: false
)

Page.find_or_create_by!(
  title: 'Čo je vlastne to EID, o ktorom sa tu všade píše?',
  content: 'Občiansky preukaz s čipom, na ktorom je aktivovaný BOK, ZEP PIN a ZEP PUK',
  slug: 'co-je-to-eid',
  is_faq: true
)

Page.find_or_create_by!(
  title: 'O projekte Slovensko.Digital',
  content: 'Načo je dobrý projekt Slovensko.Digital?',
  slug: 'o-projekte',
  is_faq: false
)

journey = Journey.find_or_create_by!(
  position: 1,
  title: "Založenie živnosti",
  slug: "zalozenie-zivnosti",
  short_description: "empty",
  description: "<h1>Založenie živnosti: krok po kroku</h1>
<p>Zistite, čo treba vybaviť na založenie živnosti.</p>
<p>Založenie živnosti zvyčajne trvá 5 až 10 pracovných dní.</p>",
  short_description: "Založenie živnosti krok po kroku",
  published_status: "PUBLISHED"
)

step = journey.steps.find_or_create_by!(
  position: 1,
  title: "Založte si bankový účet",
  slug: "zalozte-si-bankovy-ucet",
  description: "<h1>Založte si bankový účet</h1>
<p>Pri zakladaní živnosti si nemusíte zakladať nový bankový účet – môžete používať Váš osobný účet.</p>
<p>Je to však praktické: oddelíte tak svoje osobné a podnikateľské príjmy a výdavky, čo Vám zjednoduší prácu pri účtovníctve a daňovom priznaní.</p>

<h2>Súvisiace odkazy</h2>
<ul>
<li><a href='http://www.uspesne-podnikanie.sk/zivnostnik-a-ucet-banke' target='_blank'/>Živnostník (SZČO) a účet v banke</a> (externý zdroj)</li>
<li><a href='https://mojepodnikanie.sk/ucet/' target='_blank'/>Živnosť – podnikateľský alebo súkromný účet</a> (externý zdroj)</li>
</ul>",
)

step.tasks.find_or_create_by!(
  title: "Bankový účet založený",
  type: "SimpleTask",
)

step = journey.steps.find_or_create_by!(
  position: 2,
  title: "Ohláste svoju živnosť",
  slug: "ohlaste-svoju-zivnost",
  description: "<h1>Ohláste svoju živnosť</h1>
<p>Vaše živnostenské podnikanie je treba ohlásiť Ministerstvu vnútra.</p>
<p>Po úspešnom ohlásení Vám bude pridelené IČO (identifikačné číslo organizácie).</p>
<p>Vyplnenie formulára Vám zaberie asi 10 minút.</p>

<h2>Predtým, než začnete</h2>
<p>Budete potrebovať:</p>
<ul>
<li>Čipový preukaz (eID) a obslužný softvér</li>
<li>Webový prehliadač Internet Explorer</li>
</ul>",
)

step.tasks.find_or_create_by!(
  title: "Vyplňte formulár",
  type: "ExternalLinkTask",
  url: "https://navody.digital.sk/seeded-fill-form-link"
)

step.tasks.find_or_create_by!(
  title: "Podpíšte",
  type: "SimpleTask",
)

step = journey.steps.find_or_create_by!(
  position: 3,
  title: "Zaregistrujte sa na DPH",
  slug: "zaregistrojte-sa-na-dph",
  description: "<h1>Zaregistrujte sa na DPH</h1>
<p>Registrácia na daň z pridanej hodnoty (DPH) je povinná len v niektorých prípadoch. Využite našu službu a zistite, či sa potebujete registrovať na DPH.</p>
<p>Po registrácií na DPH vám budú udelené čísla DIČ a IČ DPH.</p>
<p>Vyplnenie formulára Vám zaberie asi 10 minút.</p>

<h2>Predtým, než začnete</h2>
<p>Budete potrebovať:</p>
<ul>
<li>Čipový preukaz (eID) a obslužný softvér</li>
<li>Webový prehliadač Internet Explorer</li>
</ul>",
)

step.tasks.find_or_create_by!(
  title: "Zistite, či sa potrebujete zaregistrovať na DPH",
  type: "SimpleTask",
)

step.tasks.find_or_create_by!(
  title: "Zaregistrujte sa na DPH",
  type: "SimpleTask",
)

CurrentTopic.find_or_create_by!(
  # key: 'Brexit',
  body: 'A Brexit deal has been agreed but needs to be ratified',
  enabled: true
)

Upvs::FormTemplateRelatedDocument.find_or_create_by!(
  posp_id: "App.GeneralAgenda",
  posp_version: "1.9",
  message_type: "App.GeneralAgenda",
  xsd_schema: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><xs:schema elementFormDefault=\"qualified\" attributeFormDefault=\"unqualified\" xmlns:xs=\"http://www.w3.org/2001/XMLSchema\" targetNamespace=\"http://schemas.gov.sk/form/App.GeneralAgenda/1.9\" xmlns=\"http://schemas.gov.sk/form/App.GeneralAgenda/1.9\">\n" +
  "<xs:simpleType name=\"textArea\">\n" +
  "<xs:restriction base=\"xs:string\">\n" +
  "</xs:restriction>\n" +
  "</xs:simpleType>\n" +
  "<xs:simpleType name=\"meno\">\n" +
  "<xs:restriction base=\"xs:string\">\n" +
  "</xs:restriction>\n" +
  "</xs:simpleType>\n" +
  "\n" +
  "\n" +
  "<xs:element name=\"GeneralAgenda\">\n" +
  "<xs:complexType>\n" +
  "<xs:sequence>\n" +
  "<xs:element name=\"subject\" type=\"meno\" minOccurs=\"0\" nillable=\"true\" />\n" +
  "<xs:element name=\"text\" type=\"textArea\" minOccurs=\"0\" nillable=\"true\" />\n" +
  "</xs:sequence>\n" +
  "</xs:complexType>\n" +
  "</xs:element>\n" +
  "</xs:schema>\n" +
  "\n",
  xslt_transformation: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><xsl:stylesheet version=\"1.0\" xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"  xmlns:egonp=\"http://schemas.gov.sk/form/App.GeneralAgenda/1.9\"><xsl:output method=\"text\" indent=\"yes\" omit-xml-declaration=\"yes\"/><xsl:strip-space elements=\"*\" /><xsl:template match=\"egonp:GeneralAgenda\"><xsl:text>Všeobecná agenda</xsl:text><xsl:apply-templates/></xsl:template><xsl:template match=\"egonp:GeneralAgenda/egonp:subject\"><xsl:if test=\"./text()\"><xsl:text>&#xA;</xsl:text><xsl:text>&#09;</xsl:text><xsl:text>Predmet:</xsl:text><xsl:call-template name=\"string-replace-all\"><xsl:with-param name=\"text\" select=\".\" /><xsl:with-param name=\"replace\" select=\"'&#10;'\" /><xsl:with-param name=\"by\" select=\"'&#13;&#10;&#09;'\" /></xsl:call-template></xsl:if></xsl:template><xsl:template match=\"egonp:GeneralAgenda/egonp:text\"><xsl:if test=\"./text()\"><xsl:text>&#xA;</xsl:text><xsl:text>&#09;</xsl:text><xsl:text>Text:</xsl:text><xsl:call-template name=\"string-replace-all\"><xsl:with-param name=\"text\" select=\".\" /><xsl:with-param name=\"replace\" select=\"'&#10;'\" /><xsl:with-param name=\"by\" select=\"'&#13;&#10;&#09;'\" /></xsl:call-template></xsl:if></xsl:template><xsl:template name=\"formatToSkDate\"><xsl:param name=\"date\" /><xsl:variable name=\"dateString\" select=\"string($date)\" /><xsl:choose><xsl:when test=\"$dateString != '' and string-length($dateString)=10 and string(number(substring($dateString, 1, 4))) != 'NaN' \"><xsl:value-of select=\"concat(substring($dateString, 9, 2), '.', substring($dateString, 6, 2), '.', substring($dateString, 1, 4))\" /></xsl:when><xsl:otherwise><xsl:value-of select=\"$dateString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"booleanCheckboxToString\"><xsl:param name=\"boolValue\" /><xsl:variable name=\"boolValueString\" select=\"string($boolValue)\" /><xsl:choose><xsl:when test=\"$boolValueString = 'true' \"><xsl:text>Áno</xsl:text></xsl:when><xsl:when test=\"$boolValueString = 'false' \"><xsl:text>Nie</xsl:text></xsl:when><xsl:when test=\"$boolValueString = '1' \"><xsl:text>Áno</xsl:text></xsl:when><xsl:when test=\"$boolValueString = '0' \"><xsl:text>Nie</xsl:text></xsl:when><xsl:otherwise><xsl:value-of select=\"$boolValueString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"formatTimeTrimSeconds\"><xsl:param name=\"time\" /><xsl:variable name=\"timeString\" select=\"string($time)\" /><xsl:if test=\"$timeString != ''\"><xsl:value-of select=\"substring($timeString, 1, 5)\" /></xsl:if></xsl:template><xsl:template name=\"formatTime\"><xsl:param name=\"time\" /><xsl:variable name=\"timeString\" select=\"string($time)\" /><xsl:if test=\"$timeString != ''\"><xsl:value-of select=\"substring($timeString, 1, 8)\" /></xsl:if></xsl:template><xsl:template name=\"string-replace-all\"><xsl:param name=\"text\"/><xsl:param name=\"replace\"/><xsl:param name=\"by\"/><xsl:choose><xsl:when test=\"contains($text, $replace)\"><xsl:value-of select=\"substring-before($text,$replace)\"/><xsl:value-of select=\"$by\"/><xsl:call-template name=\"string-replace-all\"><xsl:with-param name=\"text\" select=\"substring-after($text,$replace)\"/><xsl:with-param name=\"replace\" select=\"$replace\"/><xsl:with-param name=\"by\" select=\"$by\" /></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select=\"$text\"/></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"formatToSkDateTime\"><xsl:param name=\"dateTime\" /><xsl:variable name=\"dateTimeString\" select=\"string($dateTime)\" /><xsl:choose><xsl:when test=\"$dateTimeString!= '' and string-length($dateTimeString)>18 and string(number(substring($dateTimeString, 1, 4))) != 'NaN' \"><xsl:value-of select=\"concat(substring($dateTimeString, 9, 2), '.', substring($dateTimeString, 6, 2), '.', substring($dateTimeString, 1, 4),' ', substring($dateTimeString, 12, 2),':', substring($dateTimeString, 15, 2))\" /></xsl:when><xsl:otherwise><xsl:value-of select=\"$dateTimeString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"formatToSkDateTimeSecond\"><xsl:param name=\"dateTime\" /><xsl:variable name=\"dateTimeString\" select=\"string($dateTime)\" /><xsl:choose><xsl:when test=\"$dateTimeString!= '' and string-length($dateTimeString)>18 and string(number(substring($dateTimeString, 1, 4))) != 'NaN' \"><xsl:value-of select=\"concat(substring($dateTimeString, 9, 2), '.', substring($dateTimeString, 6, 2), '.', substring($dateTimeString, 1, 4),' ', substring($dateTimeString, 12, 2),':', substring($dateTimeString, 15, 2),':', substring($dateTimeString, 18, 2))\" /></xsl:when><xsl:otherwise><xsl:value-of select=\"$dateTimeString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template></xsl:stylesheet>"
)

Upvs::FormTemplateRelatedDocument.find_or_create_by!(
  posp_id: "00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk",
  posp_version: "1.53",
  message_type: "ks_340702",
  xslt_transformation: File.read(Rails.root+"db/data/upvs_form_ks_340702.xslt")
)
