class CreateQuestionQuestionsItemTemplates < ActiveRecord::Migration[5.2]
  def change
    create_table :question_questions_item_templates do |t|
      t.belongs_to :question_question, foreign_key: true, null: false
      t.belongs_to :question_item_template, foreign_key: true, index: { name: 'idx_questions_item_templates_on_item_template_id' }

      t.integer :type, default: 0 # key, value

      t.integer :font_size, default: 1 # pequeno, medio, grande
      t.integer :total_per_line, default: 1 # quantos itens por linha

      t.string :custom # item customizado

      t.jsonb :tags
      t.jsonb :info, default: '{}'

      t.timestamps
    end
  end
end
