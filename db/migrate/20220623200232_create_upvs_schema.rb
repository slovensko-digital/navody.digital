class CreateUpvsSchema < ActiveRecord::Migration[6.1]
  def up
    execute 'CREATE SCHEMA upvs'
  end

  def down
    execute 'DROP SCHEMA upvs'
  end
end
