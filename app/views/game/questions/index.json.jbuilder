json.partial! 'game/units/unit', modulo: @unit.theme.modulo, theme: @unit.theme, unit: @unit

json.questions do
  json.array! @questions do |q|
    json.partial! 'game/questions/info', q: q
  end
end
