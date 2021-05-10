json.id q.id
json.order q.order

json.module_id q.modulo.id
json.theme_id q.theme.id
json.unit_id q.unit_id

json.module do
  json.extract! q.modulo, :id, :slug, :title, :order
end

json.theme do
  json.extract! q.theme, :id, :slug, :title, :order
end

json.unit do
  json.extract! q.unit, :id, :slug, :title, :order
end

json.type do
  json.extract! q.type, :id, :title, :slug
end

json.subtype do
  json.extract! q.subtype, :id, :title, :slug
end

json.total_correct_items calculate_total_correct_items

json.pointings do
  json.array! q.pointings do |pointing|
    json.extract! pointing, :type, :quantity
  end
end

json.title do
  json.extract! q.title, :type, :text

  json.image q.title.image_full_url
  json.audio q.title.audio_full_url
end

json.statement do
  if q.descriptions.any?
    description = q.descriptions.last

    json.extract! description, :type, :text

    json.image description.image_full_url
    json.audio description.audio_full_url
  end
end

json.item_template do
  json.partial! 'game/questions/item_template', q: q
end

json.items do
  json.partial! 'game/questions/items_random', q: q
end
