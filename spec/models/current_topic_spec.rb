require 'rails_helper'

RSpec.describe CurrentTopic, type: :model do

  context 'active' do
    it 'returns current active topic when enabled' do
      current_topic = create(:current_topic)
      active_current_topic = CurrentTopic.active
      expect(active_current_topic).to eq current_topic
    end

    it 'returns nil when its not enabled' do
      current_topic = create(:current_topic)
      current_topic.enabled = false
      current_topic.save!
      active_current_topic = CurrentTopic.active
      expect(active_current_topic).to eq nil
    end

    it 'returns nil when key is empty' do
      current_topic = create(:current_topic)
      current_topic.key = ""
      current_topic.save!
      active_current_topic = CurrentTopic.active
      expect(active_current_topic).to eq nil
    end

    it 'returns nil when value is empty' do
      current_topic = create(:current_topic)
      current_topic.key = ""
      current_topic.save!
      active_current_topic = CurrentTopic.active
      expect(active_current_topic).to eq nil
    end
  end

end
