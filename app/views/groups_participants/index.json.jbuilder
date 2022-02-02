json.array! @groups_participants.each do |groups_participant|
  json.extract! groups_participant, :user, :type, :status, :id
end
