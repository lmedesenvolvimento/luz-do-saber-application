class AddQuestionTemplateToQuestions < ActiveRecord::Migration[5.2]
  def change
    change_table :question_questions do |t|
      t.belongs_to :question_question_template, foreign_key: true
    end
  end
end
