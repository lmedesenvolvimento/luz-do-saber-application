class Question::QuestionsGroup < ApplicationRecord
  belongs_to :question, foreign_key: :question_question_id, class_name: 'Question::Question'
  belongs_to :group
end
