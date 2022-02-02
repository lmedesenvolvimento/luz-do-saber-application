class WordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, :if => :api_query_request?

  before_action :set_default_filter, only: :index
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  def index
    @q = policy_scope(Word).order(:text).ransack(params[:q])
    @words = @q.result.order(:type).page(params[:page])

    @words.each do |word| 
      word.audios.each do |w| 
        if w.attachment_file_name.present?
          n = w.attachment_file_name.downcase 
          w.attachment_file_name = n
        end
      end
      word.images.each do |w| 
        if w.attachment_file_name.present?
          n = w.attachment_file_name.downcase
          w.attachment_file_name = n 
        end
      end

    end
  end

  # GET /words/1
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
    0.times { @word.elements.build }
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words
  def create
    @word = Word.new(word_params)
    @word.user = current_user

    if @word.save
      respond_to do |format|
        format.json { render :show }
        format.html { redirect_to @word, notice: t('helpers.submit.saved') }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @word.errors } }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /words/1
  def update
    #nao estava excluindo word_elements - havia rollback; excluindo manualmente
    #outras paginas chamam o update, nao apenas o cadastro de palavras
    if (params[:word][:elements_attributes].present?)
      params[:word][:elements_attributes].delete_if { |k,v| v["_destroy"] == '1' }

      #edicao gravava na ordem de alteracao dos elementos, o que gerava mistura de silabas em algumas situacoes
      #removendo elementos para q sejam inseridos na ordem correta
      wnovo = {}
      params[:word][:elements_attributes].each do |k,v| 
        wnovo.store( k , {"type" =>  v["type"], "text" => v["text"] })
      end
      @word.word_elements.destroy_all
      params[:word][:elements_attributes] = wnovo
    end

    if @word.update(word_params)
      respond_to do |format|
        format.json { render json: { success: true } }
        format.html { redirect_to @word, notice: t('helpers.submit.saved') }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, errors: @word.errors } }
        format.html { render :edit }
      end
    end
  end

  # DELETE /words/1
  def destroy
    @word.destroy
    redirect_to words_url, notice: t('helpers.submit.destroyed')
  end

  private

  def api_query_request?
    action_name == 'index' && request.format.json?
  end

  def set_default_filter
    params[:q] ||= {}
    # params[:q][:type_in] ||= Word.types['substantivo_comum'].to_s
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_word
    @word = Word.find(params[:id])

    @word.audios.each do |w| 
      if w.attachment_file_name.present?
        n = w.attachment_file_name.downcase 
        w.attachment_file_name = n
      end
    end
    @word.images.each do |w| 
      if w.attachment_file_name.present?
        n = w.attachment_file_name.downcase
        w.attachment_file_name = n 
      end
    end
  end

  # Only allow a trusted parameter "white list" through.
  def word_params
    #exclusao de word_elements nao estava acontecendo
    #ActionController::Parameters.permit_all_parameters = true
    #params[:word][:word_elements_attributes] = (params[:word][:elements_attributes].to_h.each.select { |a| a.last['_destroy'] != "false" }).map do |a|
    #  { id: @word.word_elements.find_by(element_id: a.last['id']).id, "_destroy": '1' }
    #end

    ActionController::Parameters.permit_all_parameters = false

    params.require(:word).permit(:type,
                                 :text,
                                 :gender,
                                 word_elements_attributes: [ :_destroy, :id ],
                                 elements_attributes: [ :_destroy, :id, :type, :text ],
                                 images_attributes: [ :_destroy, :id, :attachment, :remote_url ],
                                 audios_attributes: [ :_destroy, :id, :attachment, :remote_url ])
  end
end
