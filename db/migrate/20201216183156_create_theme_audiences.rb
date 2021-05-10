class CreateThemeAudiences < ActiveRecord::Migration[5.2]
  def change
    create_table :theme_audiences do |t|
      t.string :title, null: false
      t.string :description
      t.attachment :cover
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
