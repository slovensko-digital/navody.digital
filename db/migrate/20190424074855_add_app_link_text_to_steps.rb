class AddAppLinkTextToSteps < ActiveRecord::Migration[5.2]
  def change
    add_column :steps, :app_link_text, :string
  end
end
