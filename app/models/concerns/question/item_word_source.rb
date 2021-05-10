require 'active_support/concern'

# O item indica como a palavra deve ser gerada.
module Question::ItemWordSource
  extend ActiveSupport::Concern

  private

  # Encontra uma palavra (Word) de acordo com o word_source_type e word_type.
  # O word_source_type informa como o item espera que a palavra seja gerada.
  def word_from_source(keys:, values:, external_words:)
    case word_source_type
    when 'random'                         then source_random keys, values

    when 'key_same'                       then source_key_same keys
    when 'key_different'                  then source_key_different keys, values

    when 'external_param'                 then source_external_param external_words, keys, values
    when 'external_param_different'       then source_external_param_different external_words, keys, values
    when 'external_param_variation'       then source_external_param_variation external_words, keys, values
    when 'external_param_similar'         then source_external_param_similar external_words, keys, values
    when 'external_param_similar_male'    then source_external_param_similar external_words, keys, values, 'm'
    when 'external_param_similar_female'  then source_external_param_similar external_words, keys, values, 'f'

    when 'input_custom'                   then source_input_custom
    end
  end

  # O input vem de um input do professor.
  def source_input_custom
    return word if word.present?

    Word.input_custom.new text: "input-#{SecureRandom.hex(4)}"
  end

  # O item espera uma palavra aleatoria, mas que nao se repita.
  def source_random(keys, values)
    Word.where(type: word_type)
        .where('text NOT IN (?)', already_used_texts(keys, values))
        .order(Arel.sql('random()')).last
  end

  # O item espera a mesma palavra do item KEY.
  def source_key_same(keys)
    keys.select { |k| k.id == self.key_id }.last.try(:word)
  end

  # A palavra comeca com uma letra diferente.
  def source_key_different(keys, values)
    Word.where(type: word_type).different text: source_key_same(keys).text,
                                 exclude_texts: already_used_texts(keys, values)
  end

  # TODO: [remove]
  # Similar ao key_same.
  def source_external_param(external_words, keys, values)
    external_words[total_items(keys, values)]
  end

  # A palavra gerada deve ser uma variacao (INICIANDO COM LETRA DIFERENTE) da palavra externa.
  def source_external_param_variation(external_words, keys, values)
    word = external_words[total_items(keys, values)] || external_words.first

    # Variacao do parametro externo.
    text_variation = word.variations(except: already_used_texts(keys, values)).sample

    Word.new type: word_type,
             text: text_variation
  end

  # A palavra gerada deve ser diferente (INICIANDO COM LETRA DIFERENTE) da palavra externa.
  def source_external_param_different(external_words, keys, values)
    word = external_words[total_items(keys, values)] || external_words.first

    Word.where(type: word_type).different text: word.text,
                                 exclude_texts: already_used_texts(keys, values)
  end

  # A palavra gerada deve ser similar (INICIANDO COM A MEMSA LETRA) da palavra externa.
  def source_external_param_similar(external_words, keys, values, gender = nil)
    word = external_words[total_items(keys, values)] || external_words.first

    Word.where(type: word_type).similar text: word.text,
                               exclude_texts: already_used_texts(keys, values),
                                      gender: gender
  end
end
