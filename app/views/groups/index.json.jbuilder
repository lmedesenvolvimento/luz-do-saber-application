json.array! @groups do |group|
  json.extract! group, :id, :code, :name, :description, :participants, :questions_groups, :questions, :user
end
