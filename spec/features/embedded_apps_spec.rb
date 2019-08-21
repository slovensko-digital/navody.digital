require 'rails_helper'

RSpec.feature "Custom components" do

  feature 'Embedded apps' do
    let!(:journey) { create(:journey) }
    let!(:child_birth_step) { create(:step, journey: journey, description: '<embedded-app app-id="narodenie-rodny-list" />') }

    scenario 'inserts the Child Birth Picking up Protocol app' do
      visit journey_step_path(journey, child_birth_step)
      expect(page).to have_content('Slobodná')
    end
  end

  feature 'Notification subscriptions' do
    let!(:journey) { create(:journey, description: '<embedded-app app-id="notification-subscription" type="BlankJourneySubscription" />') }
    let!(:step) { create(:step, journey: journey, description: '<embedded-app app-id="notification-subscription" type="BlankJourneySubscription NextVoteSubscription" />') }

    scenario 'inserts embedded notification subscription component in a journey' do
      visit journey_path(journey)
      expect(page).to have_button('Chcem dostávať tieto notifikácie')
    end

    scenario 'inserts embedded notification subscription component in a step' do
      visit journey_step_path(journey, step)
      expect(page).to have_button('Chcem dostávať tieto notifikácie')
    end

    scenario 'inserts multiple embedded notification subscription components' do
      visit journey_step_path(journey, step)
      expect(page).to have_selector "span", :text => "Zašleme Vám e-mail, keď vytvoríme tento návod alebo sa bude diať niečo relevantné."
      expect(page).to have_selector "span", :text => "Zašleme Vám upozornenie pred ďaľšími voľbami, aby ste sa mohli pripraviť."
    end
  end
end
