json.partial! 'game/units/unit', modulo: @unit.theme.modulo, theme: @unit.theme, unit: @unit

json.question do
  json.partial! 'question', q: @question
end
