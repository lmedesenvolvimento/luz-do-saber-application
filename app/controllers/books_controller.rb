class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  before_action do
    authorize Book, :manage?
  end

  # GET /books
  # GET /books.json
  def index
    @q = policy_scope(Book).ransack(params[:q])
    @books = @q.result.order(:order, :title)
  end

  # GET /books/1
  # GET /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new order: Book.next_order
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.user = current_user

    if @book.save
      redirect_to @book, notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    if @book.update(book_params)
      redirect_to @book, notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    redirect_to books_url, notice: t('helpers.submit.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def book_params
    params.require(:book).permit(:title,
                                 :subtitle,

                                 :authors,

                                 :remote_cover_url,
                                 :cover,

                                 :remote_pdf_url,
                                 :pdf,

                                 :zip_pages,
                                 :total_pages,

                                 :order,
                                 :status)
  end
end
