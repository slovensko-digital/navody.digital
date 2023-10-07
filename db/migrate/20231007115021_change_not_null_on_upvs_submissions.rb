class ChangeNotNullOnUpvsSubmissions < ActiveRecord::Migration[6.1]
  def change
    change_column_null 'upvs.submissions', :form, true
  end
end
