# As palavras sao compostas por elementos.
# Ex.: Sibalas, letras.
class WordElement < ApplicationRecord
  belongs_to :word
  belongs_to :element, class_name: 'Word'

  validates :word, :element, presence: true
end
