class CreateWordElements < ActiveRecord::Migration[5.2]
  def change
    create_table :word_elements do |t|
      t.belongs_to :word, foreign_key: true
      t.references :element, index: true

      t.timestamps
    end

    add_foreign_key :word_elements, :words, column: :element_id
  end
end
