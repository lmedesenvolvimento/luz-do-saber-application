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

  private

  def set_defaults
    self.type ||= :general
  end
end
