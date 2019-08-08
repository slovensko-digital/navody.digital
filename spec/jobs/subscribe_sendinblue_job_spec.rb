require 'rails_helper'

RSpec.describe SubscribeSendinblueJob, type: :job do
  describe '#perform_later' do
    it 'subscribes performs later' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        SubscribeSendinblueJob.perform_later('email', 'list-name')
      }.to have_enqueued_job
    end
  end

  describe '#perform_now' do
    it 'calls APIs' do
      expect(Sendinblue::Lists).to receive(:find_by_name).with('list-name').and_return(id: '34')
      expect(Sendinblue::Contact).to receive(:create).with(
        email: 'email',
        listIds: ['34'],
        updateEnabled: true
      )
      SubscribeSendinblueJob.perform_now('email', 'list-name')
    end

    context 'list not found' do
      it 'raises exception' do
        expect(Sendinblue::Lists).to receive(:find_by_name).with('list-name').and_return(nil)
        expect{
          SubscribeSendinblueJob.perform_now('email', 'list-name')
        }.to raise_error(StandardError)
      end
    end
  end
end
