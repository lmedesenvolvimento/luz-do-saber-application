# Atividades de uma unidade.
class Game::QuestionsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_unit

  def index
    @questions = if params[:group_code].present?
                    policy_scope(@unit.questions.by_group(params[:group_code]))
                  else
                    policy_scope(@unit.questions.joins(:user).where(users: { role: User.roles['admin'] }))
                  end.order(:order)
  end

  def show
    # Algumas questoes necessitam de um parametro externo com um nome.
    @external_words,
    # Itens KEY independentes de parametro externo.
    @keys,
    # Itens VALUE independentes de parametro externo.
    @values = [], [], []

    @question = policy_scope(@unit.questions).find_by!(order: params[:question_order])

    set_external_words if !@question.external_param_nenhum? && params[:external_params].present?

    # Itens independentes de parametros externos.
    set_words_to_items

    # Questoes como parametros externos podem ter itens que nao serao utilizados.
    #
    # Ex.: Questoes que recebem parametros externos tem 12 itens, mas o nome do usuario pode ocupar apenas 6.
    #      Os itens sem informacao nao devem ser exibidos.
    clean_items

  rescue => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def set_unit
    @target_audience = ThemeAudience.friendly.find(params[:target_audience_slug])
    @theme = Theme.where(:theme_audience_id => @target_audience).friendly.find(params[:theme_slug])
    @unit = Unit.where(:theme=> @theme).joins(:theme).friendly.find(params[:unit_slug])
  end

  # Remove itens sem informacao e embaralha as chaves e valores.
  def clean_items
    clean_key_items
    clean_value_items
  end

  def clean_key_items
    @keys = @keys.select { |k,_| k.word.try(:text).present? }
    @keys = @keys.to_a.shuffle if @question.shuffle_key_items
  end

  def clean_value_items
    @values = @values.select { |k,_| k.word.try(:text).present? }
    @values = @values.to_a.shuffle if @question.shuffle_value_items
  end

  # Itens que nao dependem de parametro externo.
  def set_words_to_items
    # Seta itens KEY independentes de parametros externos.
    set_words_to_key_items if @question.items.key.any?

    # Seta itens VALUE independentes de parametros externos.
    set_words_to_value_items if @question.items.value.any?
  end

  def set_words_to_key_items
    # Items tipo key desta atividade.
    @keys = @question.items.key.order(:id)

    # O item informa como ele deve ser criado.
    @keys.each { |item| item.set_word_from_source keys: @keys, values: @values, external_words: @external_words }
  end

  def set_words_to_value_items
    # Items tipo value desta atividade.
    @values = @question.items.value.order(:key_id, :id)

    # O item informa como ele deve ser criado.
    @values.each { |item| item.set_word_from_source keys: @keys, values: @values, external_words: @external_words }
  end

  # external_params = [
  #   {
  #     name: 'FULANO',
  #     image: 'IMAGE_URL'
  #   }, {...}
  # ]
  #
  # Se a questao necessita de parametros externos mas nao recebe, estes devem ser gerados usando o banco.
  def set_external_words
    # Transforma os parametros recebidos em um Hash.
    external_params = params.require(:external_params).permit!.to_h

    # Se a quantidade de parametros recebidos for menor que a necessaria, o Hash
    # deve ser completado com palavras do banco.
    unless external_params.length == @question.external_param_total
      (external_params.length..@question.external_param_total).each do |ep|
        # Completa o array de palavras externas com palavras do mesmo tipo.
        external_params[ep] = { name: Word.where(type: @question.external_param_type).sample.text }
      end
    end

    # Cria um array de palavras (Word) com os parametros recebidos.
    external_params.each do |k, word|
      # Inicializa uma palavra do tipo que a questao pede com o texto passado.
      w = Word.new type: @question.external_param_type, text: word['name']

      # Se uma URL de imagem foi passado como parametro.
      w.images << WordImage.new(external_param_image_url: word['image']) if word['image'].present?

      # Seta informacoes adicionais as palavras.
      w.set_info_data

      @external_words << w
    end
  end
end
