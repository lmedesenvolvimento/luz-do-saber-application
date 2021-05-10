require 'active_support/concern'

# Validacoes de palavras: Silabas.
module WordSilabaSubstantivo
  extend ActiveSupport::Concern

  # included do
  #   before_save :set_silaba_substantivo_info_data, if: -> { silaba? || substantivo_proprio? || substantivo_comum? }
  # end
  #
  # private

  # As palavras devem indicar as letras inicias e finais.
  def set_silaba_substantivo_info_data
    self.first_letter = text.split('').first
    self.last_letter = text.split('').last
  end
end
