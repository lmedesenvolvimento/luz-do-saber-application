class AddCodeToGroups < ActiveRecord::Migration[5.2]
  def change
    change_table :groups do |t|
      t.string :code, unique: true, index: true
    end

    change_table :users do |t|
      t.date :birthdate
      t.string :mother
    end
  end
end
