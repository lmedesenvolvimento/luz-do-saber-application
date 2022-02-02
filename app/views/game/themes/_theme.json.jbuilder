json.extract! theme, :status, :modulo_id, :id, :slug, :title, :description, :order

json.theme_audience do
  json.extract! theme.theme_audience, :id, :title, :status, :slug
  if theme.theme_audience.cover.present?
    json.cover  theme.theme_audience.cover.url
  else
    json.cover ''
  end
end if theme.theme_audience

json.target_audience theme.target_audience_i18n

# json.units_url game_units_path(modulo,target_audience, theme)

json.cover_url theme.cover_full_url
