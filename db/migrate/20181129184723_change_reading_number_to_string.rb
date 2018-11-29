class ChangeReadingNumberToString < ActiveRecord::Migration[5.2]
  def change
    change_column :readings, :number, :string
  end
end
