# Tipos paras as atividades.
class Question::Type < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  has_many :questions

  validates :title, presence: true
end
