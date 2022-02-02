class Book < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  enum status: { active: 0,
               inactive: 1 }

  belongs_to :user

  has_many :book_pages, dependent: :destroy
  accepts_nested_attributes_for :book_pages

  has_attached_file :cover,  
    styles: { medium: "300x300>" }, :path => ":path/cover.jpg"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\z/

  has_attached_file :pdf, :path => ":path/book.pdf"#, processors: [:extract]
  validates_attachment_content_type :pdf, :content_type => ['application/pdf']

  before_save :set_defaults

  validates :title, :total_pages, presence: true

  include PdfPages
  after_commit :extract_pages, on: [:create,:update], if: -> { pdf.present? }

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
      #[ENV['MINIO_HOSTNAME'], pdf.url].join('/')
      pdf.url
    else
      remote_pdf_url
    end
  end

  # Para cadastros vindo dos seeds.
  def set_defaults
    slug = title.gsub(/\s+/, "-").strip.downcase
    self.remote_cover_url ||= ['https:/', ENV['MINIO_HOSTNAME'], ENV['MINIO_BUCKET_NAME'], "books/#{slug}/cover.jpg"].join('/')
    self.remote_pdf_url ||= ['https:/', ENV['MINIO_HOSTNAME'], ENV['MINIO_BUCKET_NAME'], "books/#{slug}/book.pdf"].join('/')

    #self.remote_cover_url ||= [ENV['MINIO_HOSTNAME'], "books/#{slug}/cover.jpg"].join('/')
    #self.remote_pdf_url ||= [ENV['MINIO_HOSTNAME'], "books/#{slug}/book.pdf"].join('/')

    self.pages = (1..total_pages).map { |bp| { url: ["https://#{ENV['MINIO_HOSTNAME']}", ENV['MINIO_BUCKET_NAME'], 'books', slug, 'pages', "#{bp}.jpg"].join('/') } }
  end
end