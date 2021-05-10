class CreateKaraokes < ActiveRecord::Migration[5.2]
  def change
    create_table :karaokes do |t|
      t.string :title, null: false
      t.string :status, default: 0
      t.attachment :lyrics

      t.timestamps
    end
  end
end
