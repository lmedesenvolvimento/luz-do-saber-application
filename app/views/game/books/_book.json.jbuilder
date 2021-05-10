json.extract! book, :id, :title, :subtitle, :total_pages, :authors

json.pdf_url book.pdf_full_url

json.cover_url book.cover_full_url

json.pages book.pages
