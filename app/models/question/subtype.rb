# Subtipos paras as atividades.
class Question::Subtype < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :questions, foreign_key: :question_subtype_id

  validates :title, presence: true
end
