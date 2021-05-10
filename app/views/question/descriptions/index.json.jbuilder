json.array! @descriptions do |d|
  json.extract! d, :id, :text

  json.audio do
    json.url d.remote_audio_url
  end
end
