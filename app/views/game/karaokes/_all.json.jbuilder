json.karaokes do
  json.array! policy_scope(Karaoke).order(:title) do |karaoke|
    json.partial! 'game/karaokes/karaoke', karaoke: karaoke
  end
end
