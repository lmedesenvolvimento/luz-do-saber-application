class BookPage < ApplicationRecord
  belongs_to :book

  has_attached_file :book_page, :path => ":path_pages/:basename.:extension"
  validates_attachment_content_type :book_page, content_type: ['image/jpg', 'image/jpeg'] #/\Aimage\/.*\z/

  #altera local de envio de acordo com title do livro
  Paperclip.interpolates :path_pages do |attachment, style|
    title = attachment.instance.book.title
    ["books", title.gsub(/\s+/, '-').strip.downcase,"pages"].join('/')
  end
end