json.extract! q, :id, :status, :order, :external_param_type, :external_param_total, :total_correct_items, :user_id

json.type do
  json.extract! q.type, :slug, :title
end

json.subtype do
  json.extract! q.subtype, :slug, :title
end
