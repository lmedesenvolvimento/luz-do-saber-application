# Itens de uma atividade.
#
# Os itens sao divididos entre itens KEY e itens VALUE.
# A tabela possui um auto relacionamento que indica que os itens do tipo VALUE se relacionam com os itens do tipo KEY.
class Question::QuestionsItem < ApplicationRecord
  self.inheritance_column = :_type_disabled

  # Esse tipo define como o item sera criado e exibido na atividade.
  # Itens fixos sao key e value.
  # e podem ser gerados de acordo com o word_source.
  enum type: { key: 0,
             value: 1, }

  # Define que tipo de Word (Palavra) este item espera.
  # Caso seja um atividade com input de usuario um model Word sera gerado com esse tipo
  # de acordo com o word_source.
  # enum word_type: { letra: 0,
  #                  silaba: 1,
  #     substantivo_proprio: 2,
  #       substantivo_comum: 3,
  #                   frase: 4,
  #                  numero: 5,
  #      caractere_especial: 6,
  #            input_custom: 8,
  #                 }, _prefix: :word
  enum word_type: { letra: 0,
                   silaba: 1,
      substantivo_proprio: 2,
        substantivo_comum: 3,
                    frase: 4,
                    texto: 5,
                   numero: 6,
       caractere_especial: 7,
                  youtube: 8,
             input_custom: 9 }, _prefix: :word # O usuario, ao criar uma atividade, coloca texto sem especificar o tipo. Ex.: uma frase.

  # Esse tipo informa pra atividade como ela deve gerar cada item.
  enum word_source_type: { admin: 0, # Definido pelo admin.
                          random: 1, # Valor aleatorio.

                        key_same: 2, # Mesmo valor da chave.
                   key_different: 3, # Nao deve comecar com a mesma letra.

                  # Variacoes do valor recebido por parametro.

                  external_param: 4, # Parametro recebido pela atividade.
        external_param_different: 5, # Nao deve comecar com a mesma letra.
        external_param_variation: 6, # Muda as letras da palavra de input.
          external_param_similar: 7, # Deve comecar com a mesma letra ou silaba.
     external_param_similar_male: 8, # Deve comecar com a mesma letra mas do genero masculino.
   external_param_similar_female: 9, # Deve comecar com a mesma letra mas do genero feminino.

                    input_custom: 10, # Sem definicao do usuario. Pode ser uma frase, um texto longo, uma img, etc.
                }, _prefix: :word_source

  # Itens do tipo VALUE possuem o ID dos itens do tipo KEY.
  belongs_to :question, foreign_key: :question_question_id, optional: true
  belongs_to :word, optional: true

  # Itens do tipo VALUE podem pertencer a um item do tipo KEY.
  belongs_to :key, class_name: 'QuestionsItem', optional: true

  # keys do tipo value
  # has_many :key_items, -> { key }, foreign_key: :id, class_name: 'QuestionsItem', inverse_of: :questions_item
  # values do tipo key
  has_many :value_items, foreign_key: :key_id, class_name: 'QuestionsItem', inverse_of: :key, dependent: :destroy

  accepts_nested_attributes_for :value_items

  accepts_nested_attributes_for :word

  # Quando o item for do tipo KEY ele nao deve ter uma referencia para outra key.
  before_save :remove_key_id, if: :key?

  # TODO: [rever]
  after_create :set_question, if: -> { question_question_id.nil? && (value? || external_value?) }

  # Helpers para definicao de palavras do item.
  include Question::ItemWordHelper

  # Definicao de palavras do item padrao.
  include Question::ItemWordSource

  # Definicao de palavras do item customizada.
  include Question::ItemWordCustom

  attr_accessor :word_text

  after_initialize :set_word_from_word_text, if: -> { word_text.present? }

  has_attached_file :audio
  validates_attachment_content_type :audio, content_type: /\Aaudio\/.*\z/

  has_attached_file :image #, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def audio_full_url
    return [ENV['ASSET_HOST'], audio.url].join('/') if audio.present?
    return remote_audio_url if remote_audio_url.present?
  end

  def image_full_url
    return [ENV['ASSET_HOST'], image.url].join('/') if image.present?
    return remote_image_url if remote_image_url.present?
  end

  # Seta uma palavra (Word) no item.
  def set_word_from_source(keys:, values:, external_words:)
    # A palavra ja esta definida no item.
    return if word.present?

    self.word = find_a_word keys: keys, values: values, external_words: external_words

    # Adiciona informacoes sobre a palavra.
    self.word.set_info_data rescue nil
  end

  private

  # Apenas itens VALUE podem ter o key_id presente.
  def remove_key_id
    self.key_id = nil
  end

  def set_question
    self.update question_question_id: key.question_question_id
  end

  # TODO: Como receber o usuario criador da palavra?
  def set_word_from_word_text
    admin = User.admin.first
    self.word = case word_type
                when 'youtube'
                  Word.youtube.find_or_create_by(user: admin, text: word_text)
                when 'texto', 'frase', 'input_custom'
                  # TODO: identificar como input_custom? ou tudo que nao for substantivo, silaba e letra nao deve ser considerado?
                  # Nao e definido na base de dados.
                  Word.find_or_create_by(user: admin, type: word_type, text: word_text.upcase)
                when 'letra'
                  Word.letra.where(text: word_text.upcase).first
                else
                  # Word.where(type: word_type, text: word_text.upcase).first
                  Word.where(text: word_text.upcase).first
                end
  end
end
