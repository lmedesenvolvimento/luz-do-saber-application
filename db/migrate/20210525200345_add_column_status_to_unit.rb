class AddColumnStatusToUnit < ActiveRecord::Migration[5.2]
  def change
    change_table :units do |t|
      t.integer :status, default: 0 # ativo
    end
  end
end
