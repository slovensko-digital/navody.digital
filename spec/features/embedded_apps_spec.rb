require 'rails_helper'

RSpec.feature "Embedded apps", type: :feature, js: true do
  let!(:journey) {create(:journey)}
  let!(:child_birth_step) {create(:step, journey: journey, description: '<div data-navody-app="narodenie-rodny-list"></div>')}

  scenario 'As a user I want to see an the Child Birth Picking up Protocol app' do
    visit journey_step_path(journey, child_birth_step)
    expect(page).to have_content('Slobodná')
  end
end


