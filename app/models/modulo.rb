# Tabela de modulos do sistema.
class Modulo < ApplicationRecord
  self.inheritance_column = :_type_disabled

  extend FriendlyId
  friendly_id :title, use: :slugged

  enum type: { general: 0,
               library: 1,
               karaoke: 2 }

  enum status: { active: 0,
               inactive: 1 }

  has_many :themes

  has_many :theme_audiences, through: :themes, foreign_key: :theme_audience_id

  has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  def cover_full_url
    if cover.present?
      cover.url
    end
  end

  private

  def set_defaults
    self.type ||= :general
  end
end
