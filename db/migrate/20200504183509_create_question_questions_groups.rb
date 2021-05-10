class CreateQuestionQuestionsGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :question_questions_groups do |t|
      t.belongs_to :question_question, foreign_key: true, null: false
      t.belongs_to :group, foreign_key: true, null: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
