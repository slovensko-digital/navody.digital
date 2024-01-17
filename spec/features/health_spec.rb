require 'rails_helper'

RSpec.feature "Healthcheck", type: :feature do
  scenario 'As a healthcheck bot I want to check if everything is ok' do
    visit health_path

    expect(page.status_code).to be(200)

    returned_data = JSON.parse(page.body)

    expect(returned_data["status"]).to eq("ok")
    expect(returned_data["databases"]["primary"]).to include("status" => "ok")
    expect(returned_data["databases"]["datahub"]).to include("status" => "ok")
  end
end
