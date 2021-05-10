class Question::TypesController < ApplicationController
  before_action :set_question_type, only: [:show, :edit, :update, :destroy]

  # GET /question/types
  def index
    @types = Question::Type.all
  end

  # GET /question/types/1
  def show
  end

  # GET /question/types/new
  def new
    @type = Question::Type.new
  end

  # GET /question/types/1/edit
  def edit
  end

  # POST /question/types
  def create
    @type = Question::Type.new(question_type_params)

    if @type.save
      redirect_to @type, notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /question/types/1
  def update
    if @type.update(question_type_params)
      redirect_to @type, notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /question/types/1
  def destroy
    @type.destroy
    redirect_to question_types_url, notice: t('helpers.submit.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question_type
    @type = Question::Type.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def question_type_params
    params.require(:question_type).permit(:title, :description)
  end
end
