class AddStatusToQuestions < ActiveRecord::Migration[5.2]
  def change
    change_table :question_questions do |t|
      t.integer :status, default: 1 # ativo
    end
  end
end
