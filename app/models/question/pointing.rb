# Definicao da pontuacao de uma atividade.
# A atividade sempre comeca com 3 estrelas e o jogador vai perdendo de acordo com os valores definidos em quantity.
#
# O tipo indica se a equestao perde estrelas por tempo ou por tentativas, ou os dois.
# A leitura deve ser feita da seguinda forma para um registro (time, 60):
#   - a cada 60 segundos o jogador perde uma estrela;
# E para um registro (attempt, 2):
#   - a cada duas tentativas (erros) o jogador perde uma estrela.
class Question::Pointing < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: {
    lost_a_star_by_attempt: 0, # tentativa
    lost_a_star_by_time: 1 # tempo
  }

  belongs_to :question, foreign_key: :question_question_id, class_name: 'Question::Question'

  validates :quantity, presence: true
end
