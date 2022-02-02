class AddSubTitleToQuestion < ActiveRecord::Migration[5.2]
  def change
    change_table :question_questions do |t|
      t.string :subtitle
    end
  end
end
