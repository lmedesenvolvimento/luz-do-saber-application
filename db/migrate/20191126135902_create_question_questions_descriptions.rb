class CreateQuestionQuestionsDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_questions_descriptions do |t|
      t.belongs_to :question_question, foreign_key: true
      t.belongs_to :question_description, foreign_key: true, index: { name: 'index_questions_descriptions_on_question_description_id' }

      t.timestamps
    end

    create_question_description_relations

    change_table :question_descriptions do |t|
      t.remove :question_question_id
    end
  end

  private

  def create_question_description_relations
    execute <<-SQL
      INSERT INTO question_questions_descriptions (question_question_id, question_description_id, created_at, updated_at)
        SELECT question_question_id, id, now(), now()
          FROM question_descriptions;
    SQL
  rescue
    # do nothing
  end
end
