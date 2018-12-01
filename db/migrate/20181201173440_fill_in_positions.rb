class FillInPositions < ActiveRecord::Migration[5.2]
  def up
    [Journey, Step, Task, Page].each do |model|
      model.update_all('position = id')
    end
  end

  def down
  end
end
