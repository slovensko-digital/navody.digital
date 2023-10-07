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
  xslt_transformation: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><xsl:stylesheet version=\"1.0\"  xmlns:xsl=\"http://www.w3.org/1999/XSL/Transform\"  xmlns:egonp=\"http://schemas.gov.sk/form/App.GeneralAgenda/1.9\" exclude-result-prefixes=\"egonp\"><xsl:output method=\"html\" doctype-system=\"http://www.w3.org/TR/html4/strict.dtd\" doctype-public=\"-//W3C//DTD HTML 4.01//EN\" indent=\"no\" omit-xml-declaration=\"yes\"/><xsl:template match=\"/\"><html><head><meta http-equiv=\"X-UA-Compatible\" content=\"IE=8\" /><title>Všeobecná agenda</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><meta name=\"language\" content=\"sk-SK\"/><style type=\"text/css\">body { \r\n" +
    "\tfont-family: 'Open Sans', 'Segoe UI', 'Trebuchet MS', 'Geneva CE', lucida, sans-serif;\r\n" +
    "\tbackground : #ffffff !important ;\r\n" +
    "}\r\n" +
    ".ui-tabs {\r\n" +
    "\tpadding: .2em;\r\n" +
    "\tposition: relative;\r\n" +
    "\tzoom: 1;\r\n" +
    "}\t\t\t\t\t\t\t\t\r\n" +
    ".clear { clear: both; height: 0;}\r\n" +
    ".layoutMain {\r\n" +
    "\tmargin: 0px auto;\r\n" +
    "\tpadding: 5px 5px 5px 5px;\t\r\n" +
    "}\t\t\t\t\r\n" +
    ".layoutRow { margin-bottom: 5px; }\t\t\t\t\r\n" +
    ".caption { /*width: 100%; border-bottom: solid 1px black;*/ }\r\n" +
    ".nocaption &gt; .caption { border: 0px !important; }\r\n" +
    ".nocaption &gt; .caption span {\r\n" +
    "\tbackground: none !important;\r\n" +
    "\tdisplay: none;\r\n" +
    "} \r\n" +
    ".caption .title { padding-left: 5px; }\r\n" +
    ".headercorrection {\t\r\n" +
    "\tmargin: 0px;\r\n" +
    "    font-size : 1em;\r\n" +
    "    font-weight: bold;\r\n" +
    "}\t\t\t\t\r\n" +
    ".labelVis {\r\n" +
    "\tfloat: left;\r\n" +
    "\tfont-weight: bold;\r\n" +
    "\tfont-family: 'Open Sans', 'Segoe UI', 'Trebuchet MS', 'Geneva CE', lucida, sans-serif;\r\n" +
    "\tline-height: 25px;\r\n" +
    "\tmargin: 0px 18px 0px 0px;\r\n" +
    "\tpadding-left: 3px;\r\n" +
    "\twidth: 190px;\r\n" +
    "\tword-wrap: break-word;\r\n" +
    "    font-size: 0.8em;\r\n" +
    "}\r\n" +
    ".contentVis {    \t     \r\n" +
    "\tfloat: left;\t\r\n" +
    "\tline-height: 25px;\r\n" +
    "\tmargin: 0px;\r\n" +
    "\tpadding: 0px;\r\n" +
    "\tvertical-align: top;\r\n" +
    "    font-size: 0.75em;\t\t\t\r\n" +
    "}\r\n" +
    ".wordwrap { \r\n" +
    "    white-space: pre-wrap;      \r\n" +
    "    white-space: -moz-pre-wrap; \r\n" +
    "    white-space: -pre-wrap;     \r\n" +
    "    white-space: -o-pre-wrap;   \r\n" +
    "    word-wrap: break-word;      \r\n" +
    "}\t\r\n" +
    ".ui-widget-content {\r\n" +
    "\tbackground : 50% 50% repeat-x #ffffff;\r\n" +
    "\tborder : #d4d4d4 solid 2px;\r\n" +
    "\tcolor : #4f4e4e;\r\n" +
    "\tborder-radius : 3px;\r\n" +
    "}\r\n" +
    ".ui-widget-header {\r\n" +
    "\tcursor : pointer;\r\n" +
    "\tfont-size : 0.8em;\r\n" +
    "\tcolor : #494949;\r\n" +
    "\tpadding-left : 2px;\r\n" +
    "\tborder : #eae9e8 solid 1px;\r\n" +
    "\tbackground-color : #eae9e8;\r\n" +
    "\tmargin-bottom: 3px;\r\n" +
    "\tborder-radius : 3px;\r\n" +
    "}</style></head><body><div id=\"main\" class=\"layoutMain\"><xsl:apply-templates/></div></body></html></xsl:template><xsl:template match=\"/egonp:GeneralAgenda\"><div class=\"layoutRow ui-tabs ui-widget-content\" ><div class=\"caption ui-widget-header\"><div class=\"headercorrection\">Všeobecná agenda</div></div><xsl:apply-templates select=\"./egonp:subject\"/><xsl:apply-templates select=\"./egonp:text\"/></div></xsl:template><xsl:template match=\"egonp:GeneralAgenda/egonp:subject\"><xsl:if test=\"./text()\"><div><label class=\"labelVis\">Predmet:</label><span class=\"contentVis wordwrap\"><xsl:call-template name=\"string-replace-all\"><xsl:with-param name=\"text\" select=\".\" /><xsl:with-param name=\"replace\" select=\"'%0A'\" /><xsl:with-param name=\"by\" select=\"'&#13;&#10;'\" /></xsl:call-template></span></div><div class=\"clear\">&#xa0;</div></xsl:if></xsl:template><xsl:template match=\"egonp:GeneralAgenda/egonp:text\"><xsl:if test=\"./text()\"><div><label class=\"labelVis\">Text:</label><span class=\"contentVis wordwrap\"><xsl:call-template name=\"string-replace-all\"><xsl:with-param name=\"text\" select=\".\" /><xsl:with-param name=\"replace\" select=\"'%0A'\" /><xsl:with-param name=\"by\" select=\"'&#13;&#10;'\" /></xsl:call-template></span></div><div class=\"clear\">&#xa0;</div></xsl:if></xsl:template><xsl:template name=\"formatToSkDate\"><xsl:param name=\"date\" /><xsl:variable name=\"dateString\" select=\"string($date)\" /><xsl:choose><xsl:when test=\"$dateString != '' and string-length($dateString)=10 and string(number(substring($dateString, 1, 4))) != 'NaN' \"><xsl:value-of select=\"concat(substring($dateString, 9, 2), '.', substring($dateString, 6, 2), '.', substring($dateString, 1, 4))\" /></xsl:when><xsl:otherwise><xsl:value-of select=\"$dateString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"booleanCheckboxToString\"><xsl:param name=\"boolValue\" /><xsl:variable name=\"boolValueString\" select=\"string($boolValue)\" /><xsl:choose><xsl:when test=\"$boolValueString = 'true' \"><xsl:text>Áno</xsl:text></xsl:when><xsl:when test=\"$boolValueString = 'false' \"><xsl:text>Nie</xsl:text></xsl:when><xsl:when test=\"$boolValueString = '1' \"><xsl:text>Áno</xsl:text></xsl:when><xsl:when test=\"$boolValueString = '0' \"><xsl:text>Nie</xsl:text></xsl:when><xsl:otherwise><xsl:value-of select=\"$boolValueString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"formatTimeTrimSeconds\"><xsl:param name=\"time\" /><xsl:variable name=\"timeString\" select=\"string($time)\" /><xsl:if test=\"$timeString != ''\"><xsl:value-of select=\"substring($timeString, 1, 5)\" /></xsl:if></xsl:template><xsl:template name=\"formatTime\"><xsl:param name=\"time\" /><xsl:variable name=\"timeString\" select=\"string($time)\" /><xsl:if test=\"$timeString != ''\"><xsl:value-of select=\"substring($timeString, 1, 8)\" /></xsl:if></xsl:template><xsl:template name=\"string-replace-all\"><xsl:param name=\"text\"/><xsl:param name=\"replace\"/><xsl:param name=\"by\"/><xsl:choose><xsl:when test=\"contains($text, $replace)\"><xsl:value-of select=\"substring-before($text,$replace)\"/><xsl:value-of select=\"$by\"/><xsl:call-template name=\"string-replace-all\"><xsl:with-param name=\"text\" select=\"substring-after($text,$replace)\"/><xsl:with-param name=\"replace\" select=\"$replace\"/><xsl:with-param name=\"by\" select=\"$by\" /></xsl:call-template></xsl:when><xsl:otherwise><xsl:value-of select=\"$text\"/></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"formatToSkDateTime\"><xsl:param name=\"dateTime\" /><xsl:variable name=\"dateTimeString\" select=\"string($dateTime)\" /><xsl:choose><xsl:when test=\"$dateTimeString!= '' and string-length($dateTimeString)>18 and string(number(substring($dateTimeString, 1, 4))) != 'NaN' \"><xsl:value-of select=\"concat(substring($dateTimeString, 9, 2), '.', substring($dateTimeString, 6, 2), '.', substring($dateTimeString, 1, 4),' ', substring($dateTimeString, 12, 2),':', substring($dateTimeString, 15, 2))\" /></xsl:when><xsl:otherwise><xsl:value-of select=\"$dateTimeString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template><xsl:template name=\"formatToSkDateTimeSecond\"><xsl:param name=\"dateTime\" /><xsl:variable name=\"dateTimeString\" select=\"string($dateTime)\" /><xsl:choose><xsl:when test=\"$dateTimeString!= '' and string-length($dateTimeString)>18 and string(number(substring($dateTimeString, 1, 4))) != 'NaN' \"><xsl:value-of select=\"concat(substring($dateTimeString, 9, 2), '.', substring($dateTimeString, 6, 2), '.', substring($dateTimeString, 1, 4),' ', substring($dateTimeString, 12, 2),':', substring($dateTimeString, 15, 2),':', substring($dateTimeString, 18, 2))\" /></xsl:when><xsl:otherwise><xsl:value-of select=\"$dateTimeString\"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:template></xsl:stylesheet>"
)

Upvs::FormTemplateRelatedDocument.find_or_create_by!(
  posp_id: "00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk",
  posp_version: "1.53",
  message_type: "ks_340702",
  xslt_transformation: File.read(Rails.root+"db/data/upvs_form_ks_340702.xslt")
)
