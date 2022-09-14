class AddShortDescriptionToApps < ActiveRecord::Migration[6.1]
  def change
    add_column :apps, :short_description, :text
  end
end
