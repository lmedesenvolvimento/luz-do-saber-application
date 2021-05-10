class WordImage < ApplicationRecord
  belongs_to :word

  has_attached_file :attachment, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/

  # Imagem que o aluno envia.
  attr_accessor :external_param_image_url

  def full_url
    if attachment.present?
      # [ENV['ASSET_HOST'], attachment.url].join('/')
      attachment.url
    else
      remote_url
    end
  end
end
