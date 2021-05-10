# Enunciado de uma atividade.
class Question::QuestionsDescription < ApplicationRecord
  belongs_to :question, foreign_key: :question_question_id
  belongs_to :description, foreign_key: :question_description_id
end
