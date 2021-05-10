json.array! @groups do |group|
  json.extract! group, :id, :code, :name, :description
end
