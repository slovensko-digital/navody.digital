class CreateCodeListSchema < ActiveRecord::Migration[6.1]
  def up
    execute 'CREATE SCHEMA code_list'
  end

  def down
    execute 'DROP SCHEMA code_list'
  end
end
