require 'rails_helper'

RSpec.feature 'SEO friendly pages', type: :feature do
  background do
    @journey = create(:journey, custom_title: 'CustomJourneyTitle')
    @step = create(:step, journey: @journey, custom_title: 'CustomStepTitle')
  end

  scenario 'As a visitor I want to see a step with custom title' do
    visit journey_step_path(@journey, @step)

    expect(page).to have_title(@step.custom_title)
  end

  scenario 'As a visitor I want to see a journey with custom title' do
    visit journey_path(@journey)

    expect(page).to have_title(@journey.custom_title)
  end
end
