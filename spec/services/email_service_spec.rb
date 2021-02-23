require 'rails_helper'

RSpec.describe EmailService, type: :service do
  describe '#create_contact' do
    it 'calls API' do
      expect(SibApiV3Sdk::ContactsApi).to receive_message_chain(:new, :create_contact)
      described_class.create_contact({})
    end
  end

  describe '#find_list' do
    let(:list_stub) do
      OpenStruct.new(
        count: 3,
        lists: [
          { id: 1, name: 'List1' },
          { id: 2, name: 'List2' },
          { id: 3, name: 'List3' },
        ]
      )
    end

    before do
      expect(SibApiV3Sdk::ContactsApi)
        .to receive_message_chain(:new, :get_lists)
              .with({ limit: 50, offset: 0 })
              .and_return(list_stub)
    end

    context 'list found' do
      it 'returns list item' do
        expect(described_class.find_list('List2')).to eq({ id: 2, name: 'List2' })
      end
    end

    context 'list not found' do
      it 'returns nil' do
        expect(described_class.find_list('not-existing')).to be_nil
      end
    end
  end
end
