class AddNumberOfReadingsToThermostats < ActiveRecord::Migration[5.2]
  def change
    add_column :thermostats, :total_readings, :integer, default: 0
  end
end
