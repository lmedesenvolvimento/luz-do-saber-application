require 'active_support/concern'
require "mini_magick"
require 'tempfile'

module PdfPages
  extend ActiveSupport::Concern

  included do
    
  end

  private

  #altera local de envio de acorco com title do livro
  Paperclip.interpolates :path do |attachment, style|
    title = attachment.instance.title
    ["books", title.gsub(/\s+/, '-').strip.downcase].join('/')
  end

  def configuration
    MiniMagick.configure do |config|
      #config.cli = :graphicsmagick # or :imagemagick or :imagemagick7
      config.timeout = 120 #in seconds
    end
  end

  def save_pages(pdf, start_page, end_page)
    for ind in start_page..end_page do
      page_name = "#{ind+1}.jpg"
      page = pdf.pages[ind]

      puts "\n ********** inicio ind: #{ind} "

      file = Tempfile.new(['bk', '.jpg'])

      puts "\n --- apos tempfile "

      sleep 0.1 # precisa de um tempo adic para arq com muitas pag
      result = MiniMagick::Tool::Convert.new do |convert|
        convert.density '150' # precisa vir primeiro
        convert << page.path
        convert.quality '100'
        convert << file.path
      end

      puts "\n --- apos convert "

      file.flush
      #salva bookpage e envia img
      bp = BookPage.new
      bp.book_id = id
      bp.order = ind+1
      bp.book_page = file.open
      bp.book_page.instance_write(:file_name, page_name)
      bp.save

      puts "\n --- apos save "

      file.close(true)

      puts "\n ***** fim ind #{ind} "
    end
  end

  #extrai imagem das paginas do pdf enviado
  def extract_pages
    book = pdf.url
    position = book.index('?')
    book = book[0,position]
    book = book.sub(/https/,'http')
    # ex: book =  http://storage.seduc.ce.gov.br/luzdosaberfundamentalshare/books/teste-andorinha-1/book.pdf
    
    configuration

    #se ja existem pages, remove para reenviar
    begin
      bp = BookPage.where(book_id: id)
      if bp.present?
        #sem callback
        bp.destroy_all
      end
    rescue
    end

    puts "\n REMOVEU anteriores "

    begin
      pdf = MiniMagick::Image.open(book)

      total_pgs = pdf.pages.count

      puts "\n TOTAL PGS: #{total_pgs} "

      #pdf.pages.each_with_index do |page, index|
      len=3 # max pages por loop
      qtde = total_pgs%len==0 ? total_pgs/len : (total_pgs/len)+1 #max que salva por vez
      for i in 0..qtde-1 do
        start_page = len*i
        end_page = (start_page + len -1) > total_pgs-1 ? total_pgs-1 : (start_page + len -1)
        puts start_page
        puts end_page
        save_pages(pdf, start_page, end_page)
      end
      puts "\n ***** depois save_pages "

      # se num pag informado eh <> da qtde do pdf, atualiza pages e a qtde do pdf
      if total_pages != total_pgs
        puts "\n --- antes atualizar qtde "

        pgs = (1..total_pgs).map { |bp| { url: ["https://#{ENV['MINIO_HOSTNAME']}", ENV['MINIO_BUCKET_NAME'], 'books', slug, 'pages', "#{bp}.jpg"].join('/') } }

        #sem callback
        Book.where(:id => id).update_all(:total_pages => total_pgs, :pages => pgs)

        puts "\n --- apos atualizar qtde "
      end

    rescue => error
      puts error.to_s
      raise StandardError.new "#{error.to_s}"
    end

  end

end