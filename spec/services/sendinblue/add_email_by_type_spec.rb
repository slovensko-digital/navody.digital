require 'rails_helper'

RSpec.describe Sendinblue::AddEmailByType, type: :service do
  subject { described_class }

  context 'list name exists' do
    it 'calls bg job' do
      expect(SubscribeSendinblueJob).to receive(:perform_later).with('email', 'NewsletterSubscription')
      subject.call('email', 'NewsletterSubscription')
    end
  end

  context 'list not does not exist' do
    it 'does not call bg job' do
      expect(SubscribeSendinblueJob).not_to receive(:perform_later)
      subject.call('email', 'not-existing-type')
    end
  end
end
