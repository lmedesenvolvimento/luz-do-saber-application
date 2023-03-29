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
    third_year_complementary: 12, # 3o ano complementar
    first_year_math: 13, # 1o ano_math
    second_year_math: 14, # 2o ano_math
     third_year_math: 15, # 3o ano_math
    fourth_year_math: 16, # 4o ano_math
    fifth_year_math: 17, # 5o ano_math
    sixth_year_math: 18, # 6o ano_math
    seventh_year_math: 19, # 7o ano_math
    eighth_year_math: 20, # 8o ano_math
    ninth_year_math: 21, # 9o ano_math
    first_year_complementary_math: 22, # 1o ano complementar_math
    second_year_complementary_math: 23, # 2o ano complementar_math
    third_year_complementary_math: 24 # 3o ano complementar_math
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
