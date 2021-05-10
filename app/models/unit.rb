# Unidades.
class Unit < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  belongs_to :theme

  has_one :modulo, through: :theme

  has_many :questions, class_name: 'Question::Question'

  before_create :set_default_image

  has_attached_file :cover,
                    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  def self.next_order
    self.maximum(:order).try(:next) || 1
  end

  def cover_full_url
    if cover.present?
      cover.url
    else
      remote_cover_url
    end
  end

  private

  def set_default_image
    self.remote_cover_url ||= [ENV['ASSET_HOST'], "images/modulos/#{modulo.slug}/#{theme.target_audience_i18n}/#{theme.slug}/#{slug}.png"].join('/')
  end
end
