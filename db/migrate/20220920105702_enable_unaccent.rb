class EnableUnaccent < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'unaccent'
  end
end
