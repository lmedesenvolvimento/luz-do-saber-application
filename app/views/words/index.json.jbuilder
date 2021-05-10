json.array! @words do |w|
  json.extract! w, :id, :type, :text, :info

  json.images w.images do |img|
    json.id  img.id
    json.url img.full_url
  end

  json.audios w.audios do |audio|
    json.url audio.full_url
  end
end
