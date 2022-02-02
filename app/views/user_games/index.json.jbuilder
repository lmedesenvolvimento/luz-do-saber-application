json.array! @user_games do |d|
  json.extract! d, :id, :name, :code, :created_at, :unique_session_id, :game
end
