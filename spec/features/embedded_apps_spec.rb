require 'rails_helper'

RSpec.feature "Embedded apps", type: :feature do
  let!(:journey) {create(:journey)}
  let!(:child_birth_step) {create(:step, journey: journey, description: '<embedded-app app-id="narodenie-rodny-list" />')}

  scenario 'As a user I want to see an the Child Birth Picking up Protocol app' do
    visit journey_step_path(journey, child_birth_step)
    expect(page).to have_content('Slobodná')
  end
end
