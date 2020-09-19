class CurrentTopic < ApplicationRecord

  def key
    Digest::MD5.hexdigest updated_at.to_s
  end

  def self.active
    last_current_topic = self.last

    return last_current_topic if last_current_topic.present? &&
      last_current_topic.body.present? &&
      last_current_topic.enabled == true

    nil
  end

end
