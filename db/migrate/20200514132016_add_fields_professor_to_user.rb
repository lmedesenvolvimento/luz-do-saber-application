class AddFieldsProfessorToUser < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :cpf
      t.string :rg
      t.integer :gender
      t.string :school_degree_level
    end
  end
end
