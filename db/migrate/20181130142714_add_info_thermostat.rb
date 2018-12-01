class AddInfoThermostat < ActiveRecord::Migration[5.2]
  def change
    add_column :thermostats, :max_temperature, :float, default: -1000
    add_column :thermostats, :min_temperature, :float, default: 1000

    add_column :thermostats, :max_battery_charge, :float, default: -100000
    add_column :thermostats, :min_battery_charge, :float, default: +100000

    add_column :thermostats, :max_humidity, :float, default: 0
    add_column :thermostats, :min_humidity, :float, default: 100

    add_column :thermostats, :average_humidity, :float, default: 0
    add_column :thermostats, :average_temperature, :float, default: 0
    add_column :thermostats, :average_battery_charge, :float, default: 0
  end
end
