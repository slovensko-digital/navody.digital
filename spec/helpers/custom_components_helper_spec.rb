require 'rails_helper'

RSpec.describe NotificationSubscriptionsHelper, type: :helper do
  describe 'raw_with_custom_components' do
    describe '<embedded-app />' do
      it 'renders an embedded app' do
        result = helper.raw_with_custom_components('<embedded-app app-id="narodenie-rodny-list" />')
        parsed_result = Nokogiri(result)

        expect(result).to include "Slobodná"
        expect(parsed_result.root.name).to eq 'div'
        expect(parsed_result.root['data-navody-app']).to eq 'narodenie-rodny-list'
      end

      it 'supports extra attributes' do
        parsed_result = Nokogiri(helper.raw_with_custom_components('<embedded-app app-id="narodenie-rodny-list" extra-attr="123" />'))
        expect(parsed_result.root.attributes['extra-attr'].value).to eq '123'
      end

      it 'supports multiple occurences' do
        result = helper.raw_with_custom_components('<embedded-app app-id="narodenie-rodny-list" /><embedded-app app-id="narodenie-rodny-list" />')
        expect(Nokogiri(result).xpath('.//div[@data-navody-app="narodenie-rodny-list"]').size).to eq 2
      end
    end
  end
end
