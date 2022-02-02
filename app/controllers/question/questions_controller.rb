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
    template = Question::QuestionTemplate.find_by(:id=> params[:question_question][:question_question_template_id])
    # apenas se for template indicado e for external_param
    if template.present?
      case template.slug
      when 'complete-seu-nome' then
        if params[:question_question][:items_attributes][0]["word_source_type"]=="external_param"
          # cria 12 keys e values
          params[:question_question][:items_attributes] = set_key_value
        end
      when 'desembaralhe-seu-nome' then
        # deixa apenas key para nao gerar value substantivo junto com as letras
        params[:question_question][:items_attributes] = set_value_items
      end
    end

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
    # correcao para os templates que usam quebra_palavra_em_letras no model
    case @question.template.slug
    when 'desembaralhe-seu-nome' then
      # remove do params novo value substantivo para nao gerar value junto com as letras
      if (params[:question_question][:items_attributes].present?)          
          wnovo = []
          wnovo = params[:question_question][:items_attributes]
          wnovo.each do |v|
            if !v["_destroy"].present? && v["type"] == 'key'
              v.delete :value_items_attributes
            end
          end
          params[:question_question][:items_attributes] = wnovo
      end
    when
      'palavra-secreta',
      'complete-a-palavra-com-letra'
    then
      new_word = question_question_params["items_attributes"][0]["word_text"]
      anterior=""

      # se existe elemento key para achar palavra
      if @question.items.find_by(:type=>"key").present?
        anterior=@question.items.find_by(:type=>"key").word.text
      end

      # apenas se mudou palavra ou nao tem key (erro no cadastro)
      if (new_word != anterior)
        if (params[:question_question][:items_attributes].present?)
          # remove do params items de palavra alterada
          params[:question_question][:items_attributes].delete_if { |v| v["_destroy"] == '1' }

          # altera array do param de items
          wnovo = []
          params[:question_question][:items_attributes].each do |v|
            wnovo.append( {"key_id" =>  v["key_id"], "type" =>  v["type"], "word_type" =>  v["word_type"],
                           "word_text" => v["word_text"], "remote_image_url" =>  v["remote_image_url"] })
          end
          # remove items e atribui novo array de params
          @question.items.destroy_all if anterior!=""
          params[:question_question][:items_attributes] = wnovo
        end
      end
    end
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

  def set_value_items
    wt = params[:question_question][:items_attributes][0][:word_text]
    item_key = []
    item_key.append ({"type"=>"key", "word_type"=>2, "word_text"=> wt, "remote_image_url"=>"" } )
    return item_key
  end

  def set_key_value
    wnovo = []
    for i in 1..12 do
      value_items = [{"type"=>"value", "word_type"=>"letra", "word_text"=>"", "word_source_type"=>"key_same"}]
      wnovo.append( {"type" =>  "key", "word_type" =>  "letra",
                    "word_source_type" => "external_param", "value_items_attributes" => value_items,
                    "word_text" => "", "remote_image_url" =>  "" })
    end
    return wnovo
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_question_question
    @question = Question::Question.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def question_question_params
    params.require(:question_question).permit(:question_question_template_id,
                                              :unit_id,
                                              :status,
                                              :subtitle,
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
