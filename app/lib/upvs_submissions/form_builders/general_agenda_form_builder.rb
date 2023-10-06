module UpvsSubmissions
  module FormBuilders
    class GeneralAgendaFormBuilder
      def self.build_form(form)
        xml_form = Nokogiri::XML::Builder.new do |m|
          m.GeneralAgenda('xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance', 'xmlns' => 'http://schemas.gov.sk/form/App.GeneralAgenda/1.9') do
            m.subject form.subject
            m.text_ form.text
          end
        end

        xml_form.doc.root
      end
    end
  end
end
