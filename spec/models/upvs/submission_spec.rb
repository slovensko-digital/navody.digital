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

    it 'is valid' do
      submission = described_class.new(valid_attributes)
      expect(submission).to be_valid
      expect(submission.save).to be_truthy
      expect(Upvs::Submission.last.expires_at).to be <= 20.minutes.from_now
      expect(Upvs::Submission.last.expires_at).to be > 19.minutes.from_now
    end

    context 'submit' do
      let(:submission) { described_class.new(valid_attributes) }

      it 'is valid' do
        response_dbl = instance_double('Faraday::Response')
        allow(Faraday).to receive(:post)
          .and_return(OpenStruct.new(body: { "receive_result" => 0, "save_to_outbox_result" => 0 }.to_json, status: 200))

        allow_any_instance_of(EidToken).to receive(:subject_sub).and_return("subject_sub")
        expect(submission.submit(EidToken.new("eid_token", config: nil), client: Faraday, url: 'https://testing.stub.com/')).to be_truthy
      end
    end
  end
end
