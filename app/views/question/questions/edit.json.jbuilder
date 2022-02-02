json.extract! @question, :id, :unit_id, :order

json.type do
  json.extract! @question.type, :id, :slug, :title
end

json.title do
  json.extract! @question.title, :id, :type, :text, :audio_full_url
end

json.description do
  json.extract! @question.descriptions.last, :id, :type, :text, :audio_full_url
end

json.template do
  json.extract! @question.template, :id, :slug, :name, :question_type, :question_title
end

json.items @question.items.order(:id) do |item|
  json.extract! item, :id, :type, :key_id, :word_id, :word_type, :remote_image_url, :remote_audio_url
  json.word_text item.word.try(:text)
  if(item.word.present?)
    json.word_images item.word.images do |img|
      json.id  img.id
      json.url img.full_url
    end
  end
end
