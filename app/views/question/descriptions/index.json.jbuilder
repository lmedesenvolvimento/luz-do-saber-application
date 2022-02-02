json.array! @descriptions do |d|
  json.extract! d, :id, :text, :remote_audio_url, :audio_full_url, :audio_file_name, :type

  json.audio do
    json.url d.remote_audio_url
  end
end
