class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.belongs_to :user, foreign_key: true
      t.string :slug, index: true
      t.string :title, null: false
      t.string :subtitle
      t.integer :total_pages

      t.jsonb :authors, default: []
      t.jsonb :pages, default: []

      t.string :remote_cover_url
      t.attachment :cover

      t.string :remote_pdf_url
      t.attachment :pdf

      t.attachment :zip_pages
      
      t.integer :status
      t.integer :order

      t.timestamps
    end
  end
end
