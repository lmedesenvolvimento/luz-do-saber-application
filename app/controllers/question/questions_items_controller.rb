class Question::QuestionsItemsController < ApplicationController
  before_action :set_question
  before_action :set_question_questions_item, only: [:show, :edit, :update, :destroy]

  # GET /question/questions_items
  # GET /question/questions_items.json
  def index
    @questions_items = policy_scope(@question.items).order(:id)
  end

  # GET /question/questions_items/1
  # GET /question/questions_items/1.json
  def show
  end

  # GET /question/questions_items/new
  def new
    @questions_item = @question.items.new
  end

  # GET /question/questions_items/1/edit
  def edit
  end

  # POST /question/questions_items
  # POST /question/questions_items.json
  def create
    @questions_item = @question.items.new(question_questions_item_params)

    respond_to do |format|
      if @questions_item.save
        format.html { redirect_to question_question_items_url(@question), notice: t('helpers.submit.saved') }
        format.json { render :show, status: :created, location: @questions_item }
      else
        format.html { render :new }
        format.json { render json: @questions_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /question/questions_items/1
  # PATCH/PUT /question/questions_items/1.json
  def update
    respond_to do |format|
      if @questions_item.update(question_questions_item_params)
        format.html { redirect_to question_question_items_url(@question), notice: t('helpers.submit.saved') }
        format.json { render :show, status: :ok, location: @questions_item }
      else
        format.html { render :edit }
        format.json { render json: @questions_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /question/questions_items/1
  # DELETE /question/questions_items/1.json
  def destroy
    @questions_item.destroy
    respond_to do |format|
      format.html { redirect_to question_question_items_url(@question), notice: t('helpers.submit.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def set_question
    @question = Question::Question.find(params[:question_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_question_questions_item
    @questions_item = Question::QuestionsItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def question_questions_item_params
    params.require(:question_questions_item).permit(:type, :word_type, :word_source_type, :word_id, :key_id)
  end
end
