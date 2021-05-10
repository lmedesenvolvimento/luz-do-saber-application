class CreateThemes < ActiveRecord::Migration[5.2]
  def change
    create_table :themes do |t|
      t.belongs_to :user, foreign_key: true
      t.string :title, null: false
      t.string :description
      t.attachment :cover

      t.string :slug, index: true

      t.timestamps
    end
  end
end
