require 'zip'
require 'active_support/concern'

module BookZip
  extend ActiveSupport::Concern

  included do
    after_commit :unzip_book, on: :create, if: -> { zip_pages.present? }
  end

  # def all_pages
  #   (1..total_pages).map { |page| page(page) }
  # end
  #
  # def page(page = 1)
  #   [ENV['ASSET_HOST'], 'books', slug, 'pages', "#{page}.png"].join('/')
  # end

  private

  def unzip_book
    destination = Rails.root.join('public', 'books')
    folder = "#{slug}/pages"

    extract_zip zip_pages.path, destination, folder
  end

  # file: arquivo zip [livro-1.zip]
  # destination: onde o livro vai ficar hospedado [public/books/]
  # folder: onde as paginas ficarao [livro-1/pages]
  def extract_zip(file, destination, folder)
    FileUtils.mkdir_p(destination)

    image_files = []

    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        # Apenas o nome do arquivo com extensao.
        page_img_file_name = File.basename(f.name)

        # Path completo.
        fpath = File.join(destination, folder, page_img_file_name)

        unless File.exist?(fpath)
          zip_file.extract(f, fpath)

          image_files << page_img_file_name
        end
      end
    end

    image_files_filtered = image_files.select { |f| f.split('.').last.in? %w[png jpg jpeg] }.sort

    self.pages = image_files_filtered.map { |imgf| { url: [ENV['ASSET_HOST'], 'books', slug, 'pages', imgf].join('/') }}
    self.total_pages = image_files_filtered.length
    self.save
  end
end
