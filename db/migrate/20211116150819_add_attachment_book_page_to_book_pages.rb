class AddAttachmentBookPageToBookPages < ActiveRecord::Migration[5.2]
  def change
    create_table :book_pages do |t|
      t.belongs_to :book, foreign_key: true 
      t.integer :order
      t.attachment :book_page
      t.timestamps
    end
  end
end
