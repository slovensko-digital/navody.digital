require 'rails_helper'

RSpec.feature "Healthcheck", type: :feature do
  scenario 'As a healthcheck bot I want to check if everything is ok' do
    visit health_path

    expect(page.status_code).to be(200)
  end
end
