class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.integer :number
      t.float :temperature
      t.float :humidity
      t.float :battery_charge

      t.timestamps

    end
    add_reference :readings, :thermostat, foreign_key: true
  end
end
