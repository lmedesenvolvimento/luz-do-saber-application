class WordAudio < ApplicationRecord
  belongs_to :word

  has_attached_file :attachment
  validates_attachment_content_type :attachment, content_type: /\Aaudio\/.*\z/
  # validates_attachment_content_type :attachment, content_type: [ 'audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio', 'application/octet-stream' ]

  before_validation :lowercase_filename

  #nome do audio em minusculo
  def lowercase_filename
    if attachment.present?
      n = self.attachment_file_name.downcase
      self.attachment_file_name = n
    end
  end

  def full_url
    if attachment.present?
      # [ENV['ASSET_HOST'], attachment.url].join('/')
      attachment.url
    else
      remote_url
    end
  end
end
