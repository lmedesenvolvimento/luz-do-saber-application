class CreateQuestionDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_descriptions do |t|
      t.belongs_to :question_question, foreign_key: true, null: false
      t.integer :type, default: 0
      t.string :text, null: false
      t.attachment :image
      t.attachment :audio

      t.timestamps
    end
  end
end
