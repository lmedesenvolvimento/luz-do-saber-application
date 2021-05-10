class CreateWordImages < ActiveRecord::Migration[5.2]
  def change
    create_table :word_images do |t|
      t.belongs_to :word, foreign_key: true, null: false
      t.attachment :attachment

      t.timestamps
    end
  end
end
