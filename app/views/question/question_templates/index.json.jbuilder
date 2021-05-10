json.array! @question_templates do |t|
  json.extract! t, :id, :slug, :name, :question_title, :question_description

  json.image do
    if t.image.present?
      json.url t.image.url
    end
  end
end
