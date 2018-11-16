class FixTypoOfThemostatToken < ActiveRecord::Migration[5.2]
  def change
    rename_column :thermostats, :household_toke, :household_token
  end
end
