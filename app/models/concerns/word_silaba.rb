require 'active_support/concern'

# Validacoes de palavras: Silabas.
module WordSilaba
  extend ActiveSupport::Concern

  included do
    validates :text, length: { maximum: 5 }, if: :silaba?

    # Silabas com apenas uma letra devem ser cadastradas como sendo letras
    # before_validation :set_type_for_silaba_with_one_letter, if: -> { silaba? && text.length == 1 }

    # Cria letras. Depois de um tempo sera desnecessário.
    after_create :set_letters, if: :silaba?
  end

  def letras
    elements.letra
  end

  private

  # Separa as silabas em letras.
  def set_letters
    self.elements = text.split('').reject(&:blank?).map do |l|
      # Remove acentos das letras.
      text_letter = I18n.transliterate(l.upcase)

      letter = Word.letra.where(text: text_letter).first_or_initialize
      letter.user ||= user
      letter
    end
  end
end
