require 'active_support/concern'

# Validacoes de palavras: Frase.
module WordFrase
  extend ActiveSupport::Concern

  included do
    validates :text, length: { maximum: 60 }, if: :frase?
  end
end
