# Temas.
class Theme < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :scoped, :scope => :target_audience

  enum status: { active: 0,
               inactive: 1 }

  # enum target_audience, default: 0, null: false # Publico alvo: 1o ano, 2o ano
  enum target_audience: {
        general: 0, # Geral
     first_year: 1, # 1o ano
    second_year: 2, # 2o ano
     third_year: 3, # 3o ano
    fourth_year: 4, # 4o ano
    fifth_year: 5, # 5o ano
    sixth_year: 6, # 6o ano
    seventh_year: 7, # 7o ano
    eighth_year: 8, # 8o ano
    ninth_year: 9, # 9o ano
    first_year_complementary: 10, # 1o ano complementar
    second_year_complementary: 11, # 2o ano complementar
    third_year_complementary: 12 # 3o ano complementar
  }

  belongs_to :user
  belongs_to :modulo
  belongs_to :theme_audience, required: false

  has_many :units, dependent: :restrict_with_error

  before_create :set_default_image

  has_attached_file :cover,
                    styles: { medium: "300x300>", thumb: "100x100>" }

  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  validates :title, presence: true

  def self.next_order
    self.maximum(:order).try(:next) || 1
  end

  def cover_full_url
    if cover.present?
      # [ENV['ASSET_HOST'], cover.url].join('/')
      cover.url
    else
      remote_cover_url
    end
  end

  def destroy
    if units.any?
      inactive!
    else
      super
    end
  end

  private

  def set_default_image
    self.remote_cover_url ||= [ENV['ASSET_HOST'], "images/modulos/#{modulo.slug}/#{target_audience_i18n}/#{slug}.png"].join('/')
  end
end
