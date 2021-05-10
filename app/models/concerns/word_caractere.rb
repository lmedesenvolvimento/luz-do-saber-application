require 'active_support/concern'

# Validacoes de palavras: Substantivos.
module WordCaractere
  extend ActiveSupport::Concern

  included do
    before_save :set_caractere_info_data, if: -> { caractere_especial? }
  end

  private

  # Um caractere especial pode ser um sinal de pontuacao.
  def set_caractere_info_data
    self.is_pontuation_sign = text.in? %w(? ! . ; : - ...)
  end
end
