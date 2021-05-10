json.livros do
  json.array! policy_scope(Book).order(:order, :title) do |book|
    json.partial! 'game/books/book', book: book
  end
end
