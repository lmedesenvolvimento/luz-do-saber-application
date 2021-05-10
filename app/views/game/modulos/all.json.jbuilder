json.array! @modulos do |modulo|
  json.partial! 'modulo', modulo: modulo

  json.themes modulo.themes.order(:order) do |theme|
    json.partial! 'game/themes/theme', theme: theme, modulo: modulo

    json.units theme.units.order(:order) do |unit|
      json.partial! 'game/units/unit', modulo: modulo, theme: theme, unit: unit

      json.questions unit.questions.order(:order) do |question|
        json.partial! 'game/questions/question', modulo: modulo, theme: theme, unit: unit, q: question
      end
    end
  end
end
