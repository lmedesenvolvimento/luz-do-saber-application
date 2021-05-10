class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.string :name, null: false
      t.string :description

      t.timestamps
    end
  end
end
