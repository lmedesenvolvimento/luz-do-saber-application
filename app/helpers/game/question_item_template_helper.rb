# Helpers dos templates de item das atividades.
module Game::QuestionItemTemplateHelper
  def item_template_key_font_size(template)
    key_custom_size = item_template_key_font_size_custom template

    return key_custom_size if key_custom_size

    return template.font_size unless template.font_size_relative?

    item_template_font_size template, @keys
  end

  def item_template_value_font_size(template)
    return template.font_size unless template.font_size_relative?

    item_template_font_size template, @values
  end

  private

  def item_template_key_font_size_custom(template)
    case template.custom
    when 'game-caixa-de-palavras' then 'small'
    end
  end

  # O tamanho da fonte eh definido pelo maior texto dos itens.
  def item_template_font_size(template, items)
    return nil if template.total_per_line.zero?
    return nil if items.empty?

    words = items.map { |v| v.word }
    bigger_word = words.sort_by { |w| w.info['total_letters'] }.last

    # TODO: diferenciar esquerda/direita cima/baixo
    items_per_line = items.length > template.total_per_line ? template.total_per_line : items.length

    calcule_by_text_size bigger_word.info['total_letters'], items_per_line
  end

  # Levar em consideracao:
  #
  #   - quantidade de itens por linha
  #   - quantidade de letras do maior item
  def calcule_by_text_size(total_letters, items_per_line)
    case total_letters
    when 0..1 # letras

      case items_per_line
      when 0..8  then 'big' # Exibe ate 8 itens por linha.
      when 9..11 then 'medium' # Exibe ate 11 itens por linha.
      else; 'small' # outros.
      end

    when 2..4 # silabas

      case items_per_line
      when 0..4 then 'big' # Exibe ate 4 itens por linha.
      when 5..6 then 'medium' # Exibe ate 6 itens por linha.
      else; 'small'
      end

    when 5..8 # palavras pequenas

      case items_per_line
      when 0..3 then 'big' # Exibe ate 3 itens por linha.
      when 4..6 then 'medium' # Exibe ate 6 itens por linha.
      else; 'small'
      end

    when 8..11 # palavras maiores

      case items_per_line
      when 0..2 then 'big' # Exibe ate 2 itens por linha.
      when 2..4 then 'medium' # Exibe ate 4 itens por linha.
      when 5..6 then 'small'
      else; 'extreme-small'
      end

    else # frases
      'extreme-small'
    end
  end
end
