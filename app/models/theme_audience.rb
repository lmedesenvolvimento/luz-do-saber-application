# Publico alvo de um tema.
class ThemeAudience < ApplicationRecord
  enum status: { active: 0,
              inactive: 1 }

  has_many :themes

  has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/
end
