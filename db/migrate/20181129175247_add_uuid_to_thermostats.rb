class AddUuidToThermostats < ActiveRecord::Migration[5.2]
  def change
    add_column :thermostats, :uuid, :uuid, default: 'uuid_generate_v4()', null: false
  end
end
