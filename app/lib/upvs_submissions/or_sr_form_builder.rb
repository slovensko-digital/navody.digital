class UpvsSubmissions::OrSrFormBuilder
  def application_for_document_copy(form)
    Nokogiri::XML::Builder.new(encoding: 'utf-8') do |m|
      m.ApplicationForDocumentCopy do
        m.parent['xmlns:e'] = 'http://schemas.gov.sk/form/00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk/1.53'
        m.parent['xmlns:xsi'] = 'http://www.w3.org/2001/XMLSchema-instance'
        m.parent['xmlns'] = 'http://schemas.gov.sk/form/00166073.MSSR_ORSR_Poziadanie_o_vyhotovenie_kopie_listiny_ulozenej_v_zbierke_listin.sk/1.53'
        m.MethodOfService do
          m.Codelist do
            m.CodelistCode '1000401'
            m.CodelistItem do
              m.ItemCode 'electronic'
              m.ItemName 'v elektronickej podobe' do
                m.parent['Language'] = 'sk'
              end
            end
          end
        end

        m.DocumentsElectronicForm do
          m.LegalPerson do
            m.Codelist do
              m.CodelistCode 'MSSR-ORSR-LegalPerson'
              m.CodelistItem do
                m.ItemCode form.business_ico
                m.ItemName form.business_name do
                  m.parent['Language'] = 'sk'
                end
                # not actually used
                m.Note form.note do
                  m.parent['Language'] = 'sk'
                end
              end
            end

            m.PersonData do
              m.PhysicalAddress do
                m.AddressLine form.business_address
              end
            end

            (form.acts || []).each do |act|
              m.Document do
                m.MakeCopy act.make_copy
                m.Code act.code
                m.Name act.name
              end
            end
          end
        end

        m.Applicant do
          m.PersonData do
            m.ElectronicAddress do
              m.InternetAddress form.email
            end
          end
        end
      end
    end
  end
end
