class NormalizeTaskAttributes < ActiveRecord::Migration[6.1]
  def change
    Task.find_each do |task|
      raise unless task.type.in? Task::TYPES

      task.url = nil if task.type != 'ExternalLinkTask' || task.url&.strip.blank?
      task.url_title = nil if task.type != 'ExternalLinkTask' || task.url_title&.strip.blank?
      task.save!
    end
  end
end
