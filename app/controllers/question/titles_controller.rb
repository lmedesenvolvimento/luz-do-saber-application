class Question::TitlesController < ApplicationController
  before_action :set_question_title, only: [:show, :edit, :update, :destroy]

  # GET /question/titles
  def index
    @titles = Question::Title.all
  end

  # GET /question/titles/1
  def show
  end

  # GET /question/titles/new
  def new
    @title = Question::Title.new
  end

  # GET /question/titles/1/edit
  def edit
  end

  # POST /question/titles
  def create
    @title = Question::Title.new(question_title_params)

    if @title.save
      redirect_to @title, notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /question/titles/1
  def update
    if @title.update(question_title_params)
      redirect_to @title, notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /question/titles/1
  def destroy
    @title.destroy
    redirect_to question_titles_url, notice: t('helpers.submit.saved')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question_title
    @title = Question::Title.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def question_title_params
    params.require(:question_title).permit(:question_question_id, :type, :text, :image, :audio)
  end
end
