class AddCodeToUserGame < ActiveRecord::Migration[5.2]
  def change
    change_table :user_games do |t|
      t.string :code
    end
  end
end
