class Karaoke < ApplicationRecord
  enum status: { active: 0,
               inactive: 1  }

  has_many :images, class_name: 'KaraokeImage', dependent: :destroy

  has_attached_file :lyrics
  # validates_attachment_content_type :lyrics, content_type: /\Atext\/.*\z/
  do_not_validate_attachment_file_type :lyrics

  has_attached_file :audio
  validates_attachment_content_type :audio, content_type: /\Aaudio\/.*\z/


  validates :title, :lyrics, :audio, presence: true

  accepts_nested_attributes_for :images, allow_destroy: true


end
