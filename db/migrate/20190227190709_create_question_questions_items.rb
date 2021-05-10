class CreateQuestionQuestionsItems < ActiveRecord::Migration[5.2]
  def change
    create_table :question_questions_items do |t|
      t.belongs_to :question_question, foreign_key: true
      t.belongs_to :word, foreign_key: true

      # Define o tipo do item.
      t.integer :word_type, default: 0
      # Define com o item deve ser gerado se for uma atividade com input de usuario.
      t.integer :word_source_type, default: 0

      # Caso seja um item value ele pode fazer referencia a um item key (indicando uma ligacao)
      t.integer :key_id, index: true
      t.integer :type
      t.jsonb :info

      t.timestamps
    end

    # O item do tipo value informa o key id
    add_foreign_key :question_questions_items, :question_questions_items, column: :key_id
  end
end
