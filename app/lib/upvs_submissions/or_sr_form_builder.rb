class UpvsSubmissions::OrSrFormBuilder
  def application_for_document_copy(form_params)
    <<~FORM
      <ApplicationForDocumentCopy xmlns:e="http://schemas.gov.sk/form/00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk/1.53" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://schemas.gov.sk/form/00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk/1.53">
        <MethodOfService>
          <Codelist>
            <CodelistCode>1000401</CodelistCode>
            <CodelistItem>
              <ItemCode>electronic</ItemCode>
              <ItemName Language="sk">v elektronickej podobe</ItemName>
            </CodelistItem>
          </Codelist>
        </MethodOfService>
        <DocumentsElectronicForm>
          <LegalPerson>
            <Codelist>
              <CodelistCode>MSSR-ORSR-LegalPerson</CodelistCode>
              <CodelistItem>
                <ItemCode>46792511</ItemCode>
                <ItemName Language="sk">freevision s. r. o. (IČO: 46792511, spisová značka: Sro/83433/B)</ItemName>
                <Note Language="sk">eyJ2YWx1ZSI6IjQ2NzkyNTExIiwidGV4dCI6ImZyZWV2aXNpb24gcy4gci4gby4gKEnEjE86IDQ2NzkyNTExLCBzcGlzb3bDoSB6bmHEjWthOiBTcm8vODM0MzMvQikiLCJ0aXRsZSI6Ik1seW5za8OpIE5pdnkgNSBCcmF0aXNsYXZhIC0gbWVzdHNrw6EgxI1hc8WlIFN0YXLDqSBNZXN0byIsImRlc2NyIjoie1xyXG4gICAgICAgICAgICBcIm9kZGllbFwiIDogMyxcclxuICAgICAgICAgICAgXCJ2bG96a2FcIiA6IDgzNDMzLFxyXG4gICAgICAgICAgICBcInN1ZFwiIDogMlxyXG4gICAgICAgIH0iLCJuYW1lIjoiZnJlZXZpc2lvbiBzLiByLiBvLiAoScSMTzogNDY3OTI1MTEsIHNwaXNvdsOhIHpuYcSNa2E6IFNyby84MzQzMy9CKSIsImNvZGUiOiI0Njc5MjUxMSJ9</Note>
              </CodelistItem>
            </Codelist>
            <PersonData>
              <PhysicalAddress>
                <AddressLine>Mlynské Nivy 5 Bratislava - mestská časť Staré Mesto</AddressLine>
              </PhysicalAddress>
            </PersonData>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>1</Code>
              <Name>Účtovná závierka za rok 2013 - Súvaha.tiff</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>2</Code>
              <Name>Účtovná závierka za rok 2013 - Poznámky.tiff</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>3</Code>
              <Name>Účtovná závierka za rok 2013 - Výkaz ziskov a strát.tiff</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>4</Code>
              <Name>Účtovná závierka za rok 2014 - Účtovná závierka - časť 1</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>5</Code>
              <Name>Účtovná závierka za rok 2014 - Účtovná závierka - časť 2</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>6</Code>
              <Name>Účtovná závierka za rok 2014 - Oznámenie o dátume schválenia 1</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>7</Code>
              <Name>Spoločenská zmluva alebo zakladateľská listina</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>8</Code>
              <Name>Listina, ktorou sa preukazuje podnikateľské oprávnenie na vykonávanie činnosti, ktorá sa má do obchodného registra zapísať ako predmet podnikania</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>9</Code>
              <Name>Písomné vyhlásenie správcu vkladu podľa osobitného zákona, 2)</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>10</Code>
              <Name>podpisovy vzor konatelov</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>11</Code>
              <Name>Účtovná závierka za rok 2015 - Účtovná závierka - časť 2</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>12</Code>
              <Name>Účtovná závierka za rok 2015 - Účtovná závierka - časť 1</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>13</Code>
              <Name>Účtovná závierka za rok 2016 - Účtovná závierka - časť 2.pdf</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>14</Code>
              <Name>Účtovná závierka za rok 2016 - Účtovná závierka - časť 1.pdf</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>15</Code>
              <Name>uplne znenie spolocenskej zmluvy.zep</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>16</Code>
              <Name>zapisnica z valneho zhromazdenia.zep</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>17</Code>
              <Name>Účtovná závierka za rok 2017 - Účtovná závierka - časť 1.pdf</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>18</Code>
              <Name>Účtovná závierka za rok 2017 - Účtovná závierka - časť 2.pdf</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>19</Code>
              <Name>Účtovná závierka za rok 2018 - Účtovná závierka - časť 1</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>20</Code>
              <Name>Účtovná závierka za rok 2018 - Účtovná závierka - časť 2</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>21</Code>
              <Name>Účtovná závierka za rok 2019 - Účtovná závierka - časť 1</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>22</Code>
              <Name>Účtovná závierka za rok 2019 - Účtovná závierka - časť 2</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>23</Code>
              <Name>Účtovná závierka za rok 2020 - Účtovná závierka - časť 2</Name>
            </Document>
            <Document>
              <MakeCopy>false</MakeCopy>
              <Code>24</Code>
              <Name>Účtovná závierka za rok 2020 - Účtovná závierka - časť 1</Name>
            </Document>
            <Document>
              <MakeCopy>true</MakeCopy>
              <Code>25</Code>
              <Name>Spoločenská zmluva.zep</Name>
            </Document>
            <Document>
              <MakeCopy>true</MakeCopy>
              <Code>26</Code>
              <Name>Zápisnica z VZ.zep</Name>
            </Document>
            <Document>
              <MakeCopy>true</MakeCopy>
              <Code>27</Code>
              <Name>Listina prítomných na VZ.zep</Name>
            </Document>
            <Document>
              <MakeCopy>true</MakeCopy>
              <Code>28</Code>
              <Name>freevision_Plnomocenstvo.zep</Name>
            </Document>
            <Document>
              <MakeCopy>true</MakeCopy>
              <Code>29</Code>
              <Name>Účtovná závierka za rok 2021 - Účtovná závierka - časť 1</Name>
            </Document>
            <Document>
              <MakeCopy>true</MakeCopy>
              <Code>30</Code>
              <Name>Účtovná závierka za rok 2021 - Účtovná závierka - časť 2</Name>
            </Document>
          </LegalPerson>
        </DocumentsElectronicForm>
        <Applicant>
          <PersonData>
            <ElectronicAddress>
              <InternetAddress>alhafoudh@freevision.sk</InternetAddress>
            </ElectronicAddress>
          </PersonData>
        </Applicant>
      </ApplicationForDocumentCopy>
    FORM
  end
end
