# Titulo de uma atividade.
class Question::Title < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: {
    texto: 0
  }

  belongs_to :question, foreign_key: :question_question_id, class_name: 'Question::Question'

  before_validation -> { self.text = self.text.upcase }

  validates :text, presence: true

  has_attached_file :audio
  validates_attachment_content_type :audio, content_type: /\Aaudio\/.*\z/

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def audio_full_url
    [ENV['ASSET_HOST'], audio.url].join('/') if audio.present?
  end

  def image_full_url
    [ENV['ASSET_HOST'], image.url].join('/') if image.present?
  end
end
