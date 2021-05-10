class AddStudentFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    change_table :users do |t|
      t.string :state
      t.string :city
      t.string :school_name
      t.integer :school_year
      t.integer :school_period
      t.string :school_group_code
      t.string :school_student_code
    end
  end
end
