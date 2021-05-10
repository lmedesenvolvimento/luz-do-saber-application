require 'active_support/concern'

# Validacoes de palavras: Letras.
module WordLetra
  extend ActiveSupport::Concern

  included do
    # before_save :set_letra_info_data, if: -> { letra? }

    # Essa validacao acontece apenas na letra pois os outros tipos dependem de validacoes posteriores.
    # validates :text, uniqueness: true, if: :letra?
    validates :text, length: { maximum: 1 }, if: -> { letra? }
    validates_format_of :text, :with => /[A-zÀ-ú]+/i, if: -> { letra? } 
  end

  private

  # Indica se a letra eh uma vogal ou consoante.
  def set_letra_info_data
    # Eh mais facil saber se uma letra eh consoante pois as vogais podem ser acentuadas.
    consonants = ('A'..'Z').to_a - %w[A E I O U]

    self.is_consonant = text.upcase.in? consonants
    self.is_vowel = !is_consonant
  end
end
