class CreateQuestionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :question_types do |t|
      t.string :title, null: false
      t.string :description
      t.string :slug, index: true
      t.jsonb :info, default: '{}'

      t.timestamps
    end

    create_table :question_subtypes do |t|
      t.string :title, null: false
      t.string :description
      t.string :slug, index: true
      t.jsonb :info, default: '{}'

      t.timestamps
    end
  end
end
