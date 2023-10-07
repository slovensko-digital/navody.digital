module UpvsSubmissions
  module FormBuilders
    class GeneralAgendaFormBuilder
      def self.build_form(form)
        xml_form = Nokogiri::XML::Builder.new do |doc|
          doc.GeneralAgenda('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
                          'xmlns' => 'http://schemas.gov.sk/form/App.GeneralAgenda/1.9') do
            doc.subject form.subject
            doc.text_ form.text
          end
        end

        xml_form.doc.root
      end
    end
  end
end
