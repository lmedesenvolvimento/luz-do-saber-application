class AddStatusToThemes < ActiveRecord::Migration[5.2]
  def change
    change_table :themes do |t|
      t.integer :status, default: 0
    end
  end
end
