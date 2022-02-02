json.theme_audiences do
  json.array! @theme_audiences do |theme_audience|
    json.partial! 'theme_audience', theme_audience: theme_audience
  end
end
