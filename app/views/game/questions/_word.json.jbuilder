json.extract! word, :type, :text

case word.type
when 'substantivo_comum', 'substantivo_proprio'
  json.extract! word, :gender, :first_letter, :last_letter, :total_letters

  json.letters do
    json.array! word.text.split('') do |l|
      letra = if l.in? %w(- , ;)
                Word.caractere_especial.new text: l
              else
                Word.letra.new text: l
              end

      letra.set_info_data

      json.extract! letra, :type, :text, :is_consonant, :is_vowel
    end
  end

  json.syllables do
    json.array! word.silabas do |s|
      json.extract! s, :type, :text, :first_letter, :last_letter, :total_letters
    end
  end
when 'silaba'
  json.extract! word, :first_letter, :last_letter, :total_letters
when 'letra'
  json.extract! word, :is_consonant, :is_vowel
when 'input_custom'
  # A palavra nao faz parte do banco de palavras pois este item eh construido com o input do professor.
  if word.input_custom? && i.word_type.present?
    # json.extract! word, :type, :text
    json.type i.word_type
    json.text word.text
  else
    json.extract! word, :type, :text
  end
end

json.images do
  # Imagem definida no item sobrescreve a imagem da palavra.
  if i.image_full_url.present?
    json.array! [i] do |item|
      json.url item.image_full_url
    end
  else
    json.array! word.images do |image|
      json.url image.full_url
    end
  end
end

json.audios do
  # Audio definido no item sobrescreve o audio da palavra.
  if i.audio_full_url.present?
    json.array! [i] do |item|
      json.url item.audio_full_url
    end
  else
    json.array! word.audios do |audio|
      json.url audio.full_url
    end
  end
end
