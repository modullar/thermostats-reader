class AddNumberIndexToReadings < ActiveRecord::Migration[5.2]
  def change
    add_index :readings, :number
  end
end
