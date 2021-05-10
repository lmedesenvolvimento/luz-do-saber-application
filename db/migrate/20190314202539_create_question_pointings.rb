class CreateQuestionPointings < ActiveRecord::Migration[5.2]
  def change
    create_table :question_pointings do |t|
      t.belongs_to :question_question, foreign_key: true, null: false
      t.integer :type, default: 0, null: false
      t.integer :quantity, null: false
      t.string :description

      t.timestamps
    end
  end
end
