class CreateUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :units do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :theme, foreign_key: true, null: false

      t.string :title
      t.string :description
      t.attachment :cover

      t.string :slug, index: true

      t.timestamps
    end
  end
end
