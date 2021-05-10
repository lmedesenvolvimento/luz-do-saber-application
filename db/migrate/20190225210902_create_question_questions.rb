class CreateQuestionQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_questions do |t|
      t.belongs_to :user, foreign_key: true, null: false
      t.belongs_to :unit, foreign_key: true, null: false

      t.belongs_to :question_type, foreign_key: true, null: false
      t.belongs_to :question_subtype, foreign_key: true, null: false

      t.integer :order, null: false
      t.string :general_info

      # Tipo de parametro externo esperado.
      t.integer :external_param_type, default: 99 # nenhum parametro
      # Total de parametros externos esperados.
      t.integer :external_param_total, default: 0 # nenhum

      t.boolean :shuffle_key_items, default: false
      t.boolean :shuffle_value_items, default: false

      t.integer :total_correct_items

      t.jsonb :info, default: '{}'

      t.timestamps
    end
  end
end
