require 'rails_helper'

RSpec.describe "Upvs::Submissions", type: :request do
  describe "POST create" do
    context "with valid params" do
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

      it "creates a new Submission" do
        expect {
          post upvs_submissions_path, params: { upvs_submission: valid_attributes }
        }.to change(Upvs::Submission, :count).by(1)
      end

      it "redirects to the created submission" do
        post upvs_submissions_path, params: { upvs_submission: valid_attributes }
        expect(response).to redirect_to(upvs_submission_path(Upvs::Submission.last))
      end

      it "creates a new Submission that expires in 20 minutes" do
        post upvs_submissions_path, params: { upvs_submission: valid_attributes }
        expect(Upvs::Submission.last.expires_at).to be <= 20.minutes.from_now
        expect(Upvs::Submission.last.expires_at).to be > 19.minutes.from_now
      end
    end

    context 'with empty recipient_uri' do
      let(:invalid_attributes) do
        {
          posp_id: 'posp_id',
          posp_version: 'posp_version',
          message_type: 'message_type',
          recipient_uri: '',
          message_subject: 'message_subject',
          form: '<form></form>',
          title: 'title'
        }
      end

      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          post upvs_submissions_path, params: { upvs_submission: invalid_attributes }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with invalid xml form' do
      let(:invalid_attributes) do
        {
          posp_id: 'posp_id',
          posp_version: 'posp_version',
          message_type: 'message_type',
          recipient_uri: 'recipient_uri',
          message_subject: 'message_subject',
          form: '<form></invalid>',
          title: 'title'
        }
      end

      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          post upvs_submissions_path, params: { upvs_submission: invalid_attributes }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "GET show" do
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

    it "renders the show template" do
      post upvs_submissions_path, params: { upvs_submission: valid_attributes }

      expect {
        get upvs_submission_path(Upvs::Submission.last)
      }.to raise_error(ActionView::Template::Error)
    end
  end
end
