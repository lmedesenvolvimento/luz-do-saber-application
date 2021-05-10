class Question::QuestionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_question_question, only: [:show, :edit, :update, :destroy, :archive, :publish]

  # GET /question/questions
  def index
    @q = policy_scope(Question::Question).ransack(params[:q])
    @questions = @q.result.order(:unit_id, :status, :order).page(params[:page])
  end

  # GET /question/questions/1
  def show
  end

  # GET /question/questions/new
  def new
    @question = Question::Question.new

    @question.build_title
    @question.build_description

    # Templates de itens.
    @question.questions_item_templates.key.build
    @question.questions_item_templates.value.build

    # Itens da atividade.
    2.times { @question.items.key.build }
    2.times { @question.items.value.build }
  end

  # GET /question/questions/1/edit
  def edit
  end

  # POST /question/questions
  def create
    @question = Question::Question.new(question_question_params)
    @question.user = current_user
    respond_to do |format|
      if @question.save
        format.json { render json: { success: true, url: question_question_url(@question) } }
        format.html { redirect_to @question, notice: t('helpers.submit.saved') }
      else
        format.json { render json: { success: false, errors: @question.errors.full_messages }, status: :unprocessable_entity }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /question/questions/1
  def update
    if @question.update(question_question_params)
      # redirect_to @question, notice: t('helpers.submit.saved')
      render json: { success: true }
    else
      render :edit
    end
  end

  # DELETE /question/questions/1
  def destroy
    @question.destroy
    redirect_to question_questions_url, notice: t('helpers.submit.destroyed')
  end

  # PUT /question/questions/1/publish
  def publish
    @question.published!
    redirect_to question_questions_url, notice: t('helpers.submit.saved')
  end
  # PUT /question/questions/1/publish
  def archive
    @question.archived!
    redirect_to question_questions_url, notice: t('helpers.submit.saved')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question_question
    @question = Question::Question.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def question_question_params
    params.require(:question_question).permit(:question_question_template_id,
                                              :unit_id,
                                              :status,
                                              :order,
                                              :description_text,
                                              description_ids: [],
                                              items_attributes: [:id,
                                                                 :type,
                                                                 :key_id,
                                                                 :word_type,
                                                                 :word_source_type,
                                                                 :word_text,
                                                                 :remote_image_url,
                                                                 :_destroy,
                                                                 value_items_attributes: [:id,
                                                                                          :_destroy,
                                                                                          :type,
                                                                                          :word_type,
                                                                                          :word_source_type,
                                                                                          :word_text,
                                                                                          :remote_image_url],
                                                                 word_attributes: [
                                                                   :id,
                                                                   :type, # input_custom / word_type: frase
                                                                   :text,
                                                                   images_attributes: [ :_destroy, :id, :attachment, :remote_url ],
                                                                   audios_attributes: [ :_destroy, :id, :attachment, :remote_url ]
                                                                 ]])
  end
end
