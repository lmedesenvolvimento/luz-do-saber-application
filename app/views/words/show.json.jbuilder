json.extract! @word, :id, :type, :text, :info

json.images @word.images do |img|
  json.id img.id
  json.url img.full_url
end

json.audios @word.audios do |audio|
  json.id audio.id
  json.url audio.full_url
end
