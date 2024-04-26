require "rails_helper"
require_relative "../../app/models/apps/ep_vote_app/application_form"

describe "EU vote application redirects", type: :request do
  before do
    allow(Apps::EpVoteApp::ApplicationForm).to receive(:active?).and_return(true)
  end

  it "should redirect inactive journey to vote application index" do
    get "/zivotne-situacie/volby-do-eu-parlamentu"
    expect(response).to redirect_to(apps_ep_vote_app_application_forms_path)
  end

  it "should redirect inactive journey step to vote application index" do
    get "/zivotne-situacie/volby-do-eu-parlamentu/krok/zistit-kde-a-ako-volit"
    expect(response).to redirect_to(apps_ep_vote_app_application_forms_path)
  end

  it "should redirect eu application members to vote application index" do
    get eu_apps_ep_vote_app_application_forms_path
    expect(response).to redirect_to(apps_ep_vote_app_application_forms_path)
  end
end
