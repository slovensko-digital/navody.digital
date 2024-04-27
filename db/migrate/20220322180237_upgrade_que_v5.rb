class UpgradeQueV5 < ActiveRecord::Migration[6.1]
  def up
    Que.migrate!(version: 5)
  end
end

