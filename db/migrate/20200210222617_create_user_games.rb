class CreateUserGames < ActiveRecord::Migration[5.2]
  def change
    create_table :user_games do |t|
      t.string :unique_session_id, null: false
      t.string :name, null: false
      t.jsonb :game, default: {}

      t.timestamps
    end
  end
end
