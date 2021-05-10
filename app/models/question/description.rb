# Descricao de uma questao.
class Question::Description < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: {
    texto: 0
  }

  # belongs_to :question, foreign_key: :question_question_id, class_name: 'Question::Question'

  before_validation -> { self.text = self.text.upcase }

  validates :text, presence: true

  has_attached_file :audio
  validates_attachment_content_type :audio, content_type: /\Aaudio\/.*\z/

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  before_create :set_default_remote_audio_url, unless: -> { audio.present? }

  def audio_full_url
    if audio.present?
      audio.url
    else
      remote_audio_url
    end
  end

  def image_full_url
    if image.present?
      [ENV['ASSET_HOST'], image.url].join('/')
    else
      remote_image_url
    end
  end

  private

  def set_default_remote_audio_url
    audio_path = ['audios', 'enunciados', "#{text.parameterize}.mp3"].join('/')

    self.remote_audio_url = [ENV['ASSET_HOST'], audio_path].join('/')
  end
end
