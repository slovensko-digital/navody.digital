require 'rails_helper'

RSpec.feature "Notification subscription components" do
  let!(:journey) { create(:journey, description: '<notification-subscription types="BlankJourneySubscription" />') }
  let!(:step) { create(:step, journey: journey, description: '<notification-subscription types="BlankJourneySubscription, NextVoteSubscription" />') }

  scenario 'inserts notification subscription component in a journey' do
    visit journey_path(journey)
    expect(page).to have_button('Chcem dostávať tieto notifikácie')
  end

  scenario 'inserts notification subscription component in a step' do
    visit journey_step_path(journey, step)
    expect(page).to have_button('Chcem dostávať tieto notifikácie')
  end

  scenario 'inserts multiple type notification subscription components' do
    visit journey_step_path(journey, step)
    expect(page).to have_css "span", text: "Zašleme Vám e-mail, keď vytvoríme tento návod alebo sa bude diať niečo relevantné."
    expect(page).to have_css "span", text: "Zašleme Vám upozornenie pred ďaľšími voľbami, aby ste sa mohli pripraviť."
  end
end
