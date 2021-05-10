class CreateWords < ActiveRecord::Migration[5.2]
  def change
    create_table :words do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.integer :type, index: true
      t.string :text, null: false, index: true
      t.jsonb :info, default: {}

      t.timestamps
    end
  end
end
