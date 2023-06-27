require 'rails_helper'

RSpec.describe Upvs::Submission, type: :model do
  context 'with valid attributes' do
    let(:valid_attributes) do
      {
        posp_id: 'posp_id',
        posp_version: 'posp_version',
        message_type: 'message_type',
        recipient_uri: 'recipient_uri',
        message_subject: 'message_subject',
        form: '<form></form>',
        title: 'title'
      }
    end

    before do
      submission = described_class.new(valid_attributes)
    end

    it 'is valid' do
      expect(submission).to be_valid
      expect(submission.save).to be_truthy
      expect(Upvs::Submission.last.expires_at).to be <= 20.minutes.from_now
      expect(Upvs::Submission.last.expires_at).to be > 19.minutes.from_now
    end
  end
end
