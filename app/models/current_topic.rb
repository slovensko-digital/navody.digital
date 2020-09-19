class CurrentTopic < ApplicationRecord

  def hashed_key
    Digest::MD5.hexdigest(key)
  end

  def self.active
    last_current_topic = self.last

    return last_current_topic if last_current_topic.present? &&
      last_current_topic.key.present? &&
      last_current_topic.value.present? &&
      last_current_topic.enabled == true

    nil
  end

end
