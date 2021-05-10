json.partial! 'game/modulos/modulo', modulo: @modulo

case @modulo.type
when 'library'
  json.partial! 'game/books/all'
when '1'
  json.partial! 'game/books/all'
when 'karaoke'
  json.partial! 'game/karaokes/all'
when '2'
  json.partial! 'game/karaokes/all'
else
  json.themes do
    json.array! @themes do |theme|
      json.partial! 'theme', modulo: @modulo, theme: theme

      json.units policy_scope(theme.units).order(:order) do |unit|
        json.partial! 'game/units/unit', modulo: @modulo, theme: theme, unit: unit
      end
    end
  end
end
