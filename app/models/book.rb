class Book < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum status: { active: 0,
               inactive: 1 }

  belongs_to :user

  has_attached_file :cover, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  has_attached_file :pdf
  # validates_attachment_content_type :pdf, content_type: /\Aimage\/.*\z/

  has_attached_file :zip_pages
  # validates_attachment_content_type :zip_pages, content_type: /\Aimage\/.*\z/

  before_save :set_defaults

  validates :title, :total_pages, presence: true

  include BookZip

  def self.next_order
    self.maximum(:order).try(:next) || 1
  end

  def cover_full_url
    if cover.present?
      # [ENV['ARQUIVOS_HOST'], cover.url].join('/')
      cover.url
    else
      remote_cover_url
    end
  end

  def pdf_full_url
    if pdf.present?
      [ENV['MINIO_HOSTNAME'], pdf.url].join('/')
    else
      remote_pdf_url
    end
  end

  private

  # Para cadastros vindo dos seeds.
  def set_defaults
    self.remote_cover_url ||= [ENV['MINIO_HOSTNAME'], "books/#{slug}/cover.jpg"].join('/')
    self.remote_pdf_url ||= [ENV['MINIO_HOSTNAME'], "books/#{slug}/book.pdf"].join('/')

    unless zip_pages.present?
      self.pages = (1..total_pages).map { |bp| { url: ["https://#{ENV['MINIO_HOSTNAME']}", ENV['MINIO_BUCKET_NAME'], 'books', slug, 'pages', "#{bp}.jpg"].join('/') } }
    end
  end
end
