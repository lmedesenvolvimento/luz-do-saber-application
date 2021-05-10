json.extract! unit, :id, :theme_id, :slug, :title, :description, :order

json.theme_audience do
  json.extract! unit.theme.theme_audience, :id, :title
  if unit.theme.theme_audience.cover.present?
    json.cover unit.theme.theme_audience.cover.url
  else
    json.cover ''
  end
end if unit.theme.theme_audience

json.target_audience unit.theme.target_audience_i18n

json.questions_url game_questions_path(modulo, theme, unit)

json.cover_url unit.cover_full_url
