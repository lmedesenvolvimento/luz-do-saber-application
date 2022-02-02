json.extract! @unit, :id, :status, :slug, :title, :description, :remote_cover_url
json.total_questions @unit.questions.count
