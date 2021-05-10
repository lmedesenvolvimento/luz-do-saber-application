require 'active_support/concern'

# Validacoes de palavras: Substantivos.
module WordSubstantivo
  extend ActiveSupport::Concern

  included do
    # Os substantivos sao cadastrados atraves de silabas.
    before_validation :set_text_from_elements, if: -> { substantivo_comum? || substantivo_proprio? }

    # Deve-se evitar cadastro repetido.
    before_validation :set_silabas, if: -> { substantivo_comum? || substantivo_proprio? }

    validates :text, length: { maximum: 20 }, if: -> { substantivo_proprio? || substantivo_comum? }
  end

  def silabas
    elements.silaba
  end

  # Gera variacoes de uma palavra.
  def variations(except: [])
    [ text.reverse,
      text.split('').shuffle.join(''),
      variate_numbers,
      variate_random_numbers,
      variate_last_letters,
      variate_random_letters ] - except
  end

  private

  # O cadastro da palavra eh feito pela juncao das silabas.
  def set_text_from_elements
    self.text = elements.map(&:text).join('').upcase
  end

  # Os substantivos sao cadastrados atraves das silabas.
  def set_silabas
    # silabas
    self.elements = self.elements.map do |e|
      t = e.text.upcase

      w = Word.silaba.where(text: t).first_or_initialize
      w.user ||= user
      w
    end
  end

  ###
  # Variacoes da palavra cadastrada.
  ###

  # Trocando vogais por numeros.
  def variate_numbers
    text.gsub(/[AÁ]/, '4').gsub(/[EÉÊ]/, '3').gsub(/[IÍ]/, '1').gsub(/[OÓÔ]/, '0').gsub(/[UÚ]/, '5')
  end

  # String com numeros aleatorios com o mesmo tamanho da palavra.
  def variate_random_numbers
    (0..text.length).map { (0..9).to_a[rand(10)] }.join
  end

  # String com letras aleatorias do mesmo tamanho da palavra.
  def variate_random_letters
    (0..text.length).map { ('A'..'Z').to_a[rand(('A'..'Z').count)] }.join
  end

  # Muda as letras finais da palavra.
  def variate_last_letters
    # Ultima letra, penultima letra
    ll, nl = text[-1], text[-2]
    # se forem iguais, gera uma letra aleatoria
    nl = ll == nl ? (('A'..'Z').to_a - [nl])[rand(('A'..'Z').count - 1)] : nl
    # muda as ultimas letras
    text[0, text.length - 2] + ll + nl
  end
end
