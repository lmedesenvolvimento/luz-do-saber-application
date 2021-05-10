json.modulos do
  json.array! @modulos do |modulo|
    json.partial! 'modulo', modulo: modulo

    json.themes policy_scope(modulo.themes).order(:order) do |theme|
      json.partial! 'game/themes/theme', modulo: modulo, theme: theme
    end
  end
end
