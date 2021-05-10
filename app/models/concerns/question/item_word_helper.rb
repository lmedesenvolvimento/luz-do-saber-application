require 'active_support/concern'

module Question::ItemWordHelper
  extend ActiveSupport::Concern

  private

  # O item da atividade indica como a palavra sera gerada.
  # Mesmo indicado um source a customizacao tem prioridade.
  def find_a_word(keys:, values:, external_words:)
    if custom_item
      word_from_custom custom: custom_item, keys: keys, values: values, external_words: external_words
    else
      # Encontra uma palavra.
      word_from_source keys: keys, values: values, external_words: external_words
    end
  end

  # Total de itens com palavras definidas.
  def total_items(keys, values)
    case type
    when 'key' then keys.select { |i| i.word.present? }.count
    when 'value' then values.select { |i| i.word.present? }.count
    end
  end

  # Textos ja definidos nos itens.
  def already_used_texts(keys, values)
    texts = [keys, values].flatten.map do |i|
      i.try(:word).try(:text)
    end.compact.uniq

    # Para nao invalidar a busca no banco de dados com NULL.
    return [''] if texts.empty?

    texts
  end
end
