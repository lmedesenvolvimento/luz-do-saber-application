json.array! @themes do |theme|
  json.extract! theme, :id, :slug, :title, :description, :target_audience

  json.units theme.units do |unit|
    json.extract! unit, :id, :slug, :title, :description, :remote_cover_url
    json.total_questions unit.questions.count
  end
end
