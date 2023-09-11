require 'rails_helper'

RSpec.describe "Upvs::Submissions", type: :request do
  let(:valid_attributes) do
    {
      posp_id: 'posp_id',
      posp_version: 'posp_version',
      message_type: 'message_type',
      recipient_uri: 'foo://bar',
      message_subject: 'message_subject',
      form: '<form>9</form>',
      title: 'title'
    }
  end

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

  let(:form_template) do
    {
      posp_id: 'posp_id',
      posp_version: 'posp_version',
      message_type: 'message_type',
      xsd_schema: '
      <?xml version="1.0"?><xs:schema><xs:element name="form" type="xs:integer"/></xs:schema>',
      xslt_transformation: '
      <?xml version="1.0"?>
      <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
      <xsl:template match="/">
        <html>
        <body>
          <xsl:value-of select="form"/>
        </body>
        </html>
      </xsl:template>
      </xsl:stylesheet>'
    }
  end

  before do
    Upvs::FormTemplateRelatedDocument.create!(form_template)
  end

  describe "POST create" do
    context "with valid params" do
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
      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          post upvs_submissions_path, params: { upvs_submission: invalid_attributes }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with invalid xml form' do
      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          post upvs_submissions_path, params: { upvs_submission: invalid_attributes }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe "GET show" do
    context "with existing submission and no token" do
      it "renders the show template" do
        post upvs_submissions_path, params: { upvs_submission: valid_attributes }
        get upvs_submission_path(Upvs::Submission.last)
        expect(response).to render_template(:show)
      end
    end

    context "with existing submission and valid token" do
      it "renders the show template" do
        post upvs_submissions_path, params: { upvs_submission: valid_attributes }
        get upvs_submission_path(Upvs::Submission.last), params: { token: "sadfasd" }
        expect(response).to render_template(:show)
      end
    end
  end

  describe "POST submit" do

    context "with valid params" do
      it "redirects to the callback url" do
        # stub valid eid_token
        allow_any_instance_of(EidToken).to receive(:valid?).and_return(true)
        allow_any_instance_of(EidToken).to receive(:api_token).and_return("eid_token")
        allow_any_instance_of(EidToken).to receive(:subject_sub).and_return("subject_sub")
        allow_any_instance_of(EidToken).to receive(:subject_name).and_return("Test User")
        # stub request to sk api
        allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(OpenStruct.new(body: { "receive_result" => 0, "save_to_outbox_result" => 0 }.to_json, status: 200))

        post upvs_submissions_path, params: { upvs_submission: valid_attributes }
        get upvs_submission_path(Upvs::Submission.last), params: { token: "token" }
        expect(response.body).to include("Prihlásiť sa pomocou slovensko.sk")

        get login_callback_upvs_submissions_path(Upvs::Submission.last), params: { token: "eid_token" }
        expect(response).to redirect_to upvs_submission_path(Upvs::Submission.last, token: "token")
        expect(session[:eid_encoded_token]).to eq("eid_token")

        get upvs_submission_path(Upvs::Submission.last), params: { token: "token" }
        expect(response.body).to include("Odoslať ako Test User")

        post upvs_submission_submit_path(Upvs::Submission.last), params: { :token => "asdfasdf", eid_token: "asdfasdf" }
        expect(response.location).to redirect_to upvs_submission_finish_path(Upvs::Submission.last)
      end
    end
  end
end
