json.extract! karaoke, :id, :title

json.lyrics do
  json.url karaoke.lyrics.url
end
json.audio do
  json.url karaoke.audio.url
end

json.images karaoke.images.order(:order) do |ki|
  json.extract! ki, :order
  json.url ki.image.url
end
