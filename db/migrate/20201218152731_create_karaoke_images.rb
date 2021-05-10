class CreateKaraokeImages < ActiveRecord::Migration[5.2]
  def change
    create_table :karaoke_images do |t|
      t.belongs_to :karaoke, foreign_key: true, null: false
      t.attachment :image
      t.integer :order

      t.timestamps
    end
  end
end
