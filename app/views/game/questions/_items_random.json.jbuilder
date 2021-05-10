json.keys do
  json.array! @keys do |i|
    json.value_ids item_key_set_value_ids(i)

    json.id i.id
    json.partial! 'word', word: i.word, i: i
  end
end

json.values do
  json.array! @values do |i|
    if i.key_id.present?
      json.key_id item_value_set_key_id(i)
    end

    json.id i.id
    json.partial! 'word', word: i.word, i: i
  end
end
