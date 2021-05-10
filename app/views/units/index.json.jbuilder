  json.units @units do |unit|
    json.extract! unit, :id, :slug, :title, :description, :remote_cover_url
    json.total_questions unit.questions.count
  end
