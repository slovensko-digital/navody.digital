require 'rails_helper'

RSpec.describe SubscribeSendinblueJob, type: :job do
  describe '#perform_now' do
    it 'calls APIs' do
      expect(NewsletterService).to receive(:find_list).with('list-name').and_return(id: '34')
      expect(NewsletterService).to receive(:create_contact).with(
        email: 'email',
        listIds: ['34'],
        updateEnabled: true
      )
      SubscribeSendinblueJob.perform_now('email', 'list-name')
    end

    context 'list not found' do
      it 'raises exception' do
        expect(NewsletterService).to receive(:find_list).with('list-name').and_return(nil)
        expect{
          SubscribeSendinblueJob.perform_now('email', 'list-name')
        }.to raise_error(StandardError)
      end
    end
  end
end
