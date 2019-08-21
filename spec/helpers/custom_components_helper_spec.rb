require 'rails_helper'

RSpec.describe CustomComponentsHelper, type: :helper do
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
        expect(Nokogiri(result).css('div[data-navody-app="narodenie-rodny-list"]').size).to eq 2
      end

      it 'supports component being deeper' do
        result = helper.raw_with_custom_components('<div><embedded-app app-id="narodenie-rodny-list" /></div>')
        expect(result).to include "Slobodná"
      end
    end

    describe '<notification-subscription />' do
      before(:each) do
        create_fake_user
      end

      it 'renders an embedded notification subscription component' do
        result = helper.raw_with_custom_components('<notification-subscription type="BlankJourneySubscription" />')

        expect(result).to include 'Zašleme Vám e-mail, keď vytvoríme tento návod alebo sa bude diať niečo relevantné.'
      end

      it 'supports multiple occurences' do
        result = helper.raw_with_custom_components('<notification-subscription type="BlankJourneySubscription" /><notification-subscription type="BlankJourneySubscription" />')
        expect(Nokogiri(result).css('input[name="notification_subscription_group[subscriptions][]"]').size).to eq 2
      end

      it 'supports component being deeper' do
        result = helper.raw_with_custom_components('<div><notification-subscription type="BlankJourneySubscription" /></div>')
        expect(result).to include 'Zašleme Vám e-mail, keď vytvoríme tento návod alebo sa bude diať niečo relevantné.'
      end

      private

      def create_fake_user
        @user = double(User, email: 'customer@test.sk', logged_in?: true)
        NotificationSubscriptionsHelper.module_eval { def current_user; @user; end }
      end
    end
  end
end
