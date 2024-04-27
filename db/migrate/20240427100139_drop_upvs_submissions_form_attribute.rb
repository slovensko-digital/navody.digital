class DropUpvsSubmissionsFormAttribute < ActiveRecord::Migration[6.1]
  def up
    remove_column 'upvs.submissions', :form
  end
end
