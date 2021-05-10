class CreateQuestionItemTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :question_item_templates do |t|
      t.integer :type, default: 0, null: false, index: true

      t.string :name, null: false
      t.string :description
      t.string :slug, index: true

      t.attachment :image

      t.timestamps
    end
  end
end
