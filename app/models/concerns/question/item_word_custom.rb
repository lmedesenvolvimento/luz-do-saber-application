require 'active_support/concern'

# O template do item informa como a palavra deve ser gerada.
# O source do item tem menos prioridade mas tb pode indicar modificacoes.
module Question::ItemWordCustom
  extend ActiveSupport::Concern

  private

  # Customizacoes.
  #
  # Na construcao do item apenas essas constumizacoes sao aceitas.
  def accepted_customs
    [
      'app-item-texto-para-item-palavra',

      'app-item-substantivo-para-item-silaba',
      'app-item-substantivo-para-item-letra',

      'app-item-substantivo-total-letras',
      'app-item-substantivo-total-silabas',

      'app-item-substantivo-primeira-letra',

      'app-helper-item-substantivo-ultima-letra',
      'app-helper-item-substantivo-consoantes',
      'app-helper-item-substantivo-vogais',

      'game-display-18-items',
    ]
  end

  # Verifica se o item deve ser customizado e se a customizacao indicada esta implementada.
  def custom_item
    # O campo custom do item recebe uma string.
    # Neste caso mais de uma customizacao poderia ser adicionada, mas eh considerada apenas a primeira antes da virgula.
    c = question.questions_item_templates.where(type: type).pluck(:custom).last.split(',').first

    return c if c.in? accepted_customs
  rescue; nil
  end

  # Encontra uma palavra (Word) de acordo com o custom, word_source_type e word_type.
  def word_from_custom(custom:, keys:, values:, external_words:)
    case custom
    when 'app-item-texto-para-item-palavra'    then custom_item_texto_para_item_palavra keys, values, external_words
    when 'app-item-substantivo-para-item-silaba' then custom_item_substantivo_para_item_silaba keys, values, external_words
    when 'app-item-substantivo-para-item-letra',
          'app-helper-item-substantivo-ultima-letra',
          'app-helper-item-substantivo-consoantes',
          'app-helper-item-substantivo-vogais' then custom_item_substantivo_para_item_letra keys, values, external_words

    when 'app-item-substantivo-total-letras'   then custom_item_substantivo_total_letras keys, values, external_words
    when 'app-item-substantivo-total-silabas'  then custom_item_substantivo_total_silabas keys, values, external_words
    when 'app-item-substantivo-primeira-letra' then custom_item_substantivo_primeira_letra keys, values, external_words

    when 'game-display-18-items'               then custom_game_display_18_items keys, values, external_words
    end
  end

  # Custom VALUE.
  def custom_item_substantivo_primeira_letra(keys, values, external_words)
    case word_source_type
    when 'key_same' then Word.letra.find_by text: source_key_same(keys).text.first
    end
  end

  # Custom VALUE.
  # O word_source_type informa como o item espera que a palavra seja gerada.
  def custom_item_substantivo_total_letras(keys, values, external_words)
    case word_source_type
    when 'random'         then source_random keys, values # o total nao importa, apenas que seja diferente
    when 'key_same'       then Word.numero.find_by text: source_key_same(keys).text.length
    when 'external_param' then Word.numero.find_by text: external_words.first.text.length
    end
  end

  # Custom VALUE.
  # O word_source_type informa como o item espera que a palavra seja gerada.
  def custom_item_substantivo_total_silabas(keys, values, external_words)
    case word_source_type
    when 'random'         then source_random keys, values # o total nao importa, apenas que seja diferente
    when 'key_same'       then Word.numero.find_by text: source_key_same(keys).silabas.count
    when 'external_param' then Word.numero.find_by text: external_words.first.silabas.count
    end
  end

  # Custom VALUE.
  # Deve ter 18 elementos.
  def custom_game_display_18_items(keys, values, external_words)
    # O limite de letras nos jogos eh de 12.
    if letter = external_words.first.text[total_items(keys, values)]
      # Cada item recebe uma letra da palavra externa.
      Word.letra.find_by(text: letter) || Word.letra.new(text: letter)
    else
      # A questao espera que o nome externo recebido tenha 12 letras.
      # Se tiver menos as lacunas devem ser preenchidas com outras letras.
      source_random keys, values
    end
  end

  def custom_item_texto_para_item_palavra(keys, values, external_words)
    case word_source_type
    when 'key_same'
      Word.new text: source_key_same(keys).text.split(' ')[total_items(keys, values)], type: word_type
    end
  end

  def custom_item_substantivo_para_item_silaba(keys, values, external_words)
    case word_source_type
    when 'key_same'
      # As silabas da palavra ja sao um objeto Word.
      source_key_same(keys).silabas[total_items(keys, values)]
    end
  end

  # Custom KEY ou VALUE.
  # Pega o primeiro parametro externo (substantivo) e transforma em items (letras).
  def custom_item_substantivo_para_item_letra(keys, values, external_words)
    # O word_source_type informa como o item espera que a palavra seja gerada.
    case word_source_type
    when 'key_same'
      letter = source_key_same(keys).text[total_items(keys, values)]

      return Word.caractere_especial.find_by(text: letter) || Word.caractere_especial.new(text: letter) if letter.in? %w(- , ;)

      Word.letra.find_by(text: letter) || Word.letra.new(text: letter)
    when 'external_param'
      letter = external_words.first.text[total_items(keys, values)]

      Word.letra.find_by(text: letter) || Word.letra.new(text: letter)
    end
  rescue;
  end
end
