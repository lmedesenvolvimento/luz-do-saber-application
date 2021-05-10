json.key do
  k = q.questions_item_templates.key.last

  if k.item_template
    json.extract! k.item_template, :type, :name, :slug

    if k.item_template.image.present?
      json.image k.item_template.image.url
    end
  end

  json.extract! k, :total_per_line, :tags, :custom_image_full_url
  json.font_size item_template_key_font_size(k)

  if k.custom && 'game-'.in?(k.custom)
    json.custom k.custom.split(',').last
  end
end

json.value do
  v = q.questions_item_templates.value.last

  if v.item_template
    json.extract! v.item_template, :type, :name, :slug

    if v.item_template.image.present?
      json.image v.item_template.image.url
    end
  end

  json.extract! v, :total_per_line, :tags, :custom_image_full_url
  json.font_size item_template_value_font_size(v)

  if v.custom && 'game-'.in?(v.custom)
    json.custom v.custom.split(',').last
  end
end
