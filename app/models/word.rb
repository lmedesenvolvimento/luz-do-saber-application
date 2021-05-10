# Banco de dados de palavras
class Word < ApplicationRecord
  self.inheritance_column = :_type_disabled

  store_accessor :info,
                 :gender,
                 :total_letters,
                 :first_letter,
                 :last_letter,
                 :is_vowel,
                 :is_consonant,
                 :is_pontuation_sign

  # Mesmos parametros usados no model Question::Question.
  enum type: { letra: 0,
              silaba: 1,
 substantivo_proprio: 2,
   substantivo_comum: 3,
               frase: 4,
               texto: 5,
              numero: 6,
  caractere_especial: 7,
             youtube: 8,
        input_custom: 9 } # O usuario, ao criar uma atividade, coloca texto sem especificar o tipo. Ex.: uma frase.

  belongs_to :user

  # As palavras sao compostas por elementos.
  has_many :word_elements, foreign_key: :word_id, dependent: :destroy, inverse_of: :word
  has_many :elements, -> { order 'word_elements.id' }, through: :word_elements, foreign_key: :element_id

  has_many :images, class_name: 'WordImage', dependent: :destroy
  has_many :audios, class_name: 'WordAudio', dependent: :destroy

  # validates :type, :text, presence: true
  validates :type, presence: true
  # validates_format_of :text, with: /[a-zA-Z]/i

  validate :validate_uniqueness, if: -> { new_record? }

  accepts_nested_attributes_for :word_elements, allow_destroy: true
  accepts_nested_attributes_for :elements, allow_destroy: false
  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :audios, allow_destroy: true

  after_initialize :set_default_type

  # Setar usuarios nos elementos derivados. Ex.: Letras e silabas sao cadastradas sem informacao de user.
  before_validation :set_user_to_elements

  before_create :set_default_audio
  before_create :set_default_image

  # Seta informacoes sobre a palavra cadastrada. Ex.: Num de letras, vogais, etc.
  before_save :set_info_data

  include WordLetra
  include WordSilaba
  include WordSubstantivo
  include WordSilabaSubstantivo
  include WordFrase
  include WordCaractere

  include ::RansackFilterByAttachment

  def self.other_numeros(numbers:, limit: 1)
    numero.where('text NOT IN (?)', numbers.map(&:to_s)).order('random()').limit(limit)
  end

  # Texto similares, iniciando com a memsa letra.
  def self.similar(text:, exclude_texts:, gender: nil)
    # Palavras que comecam com a mesma letra.
    # w = where('text LIKE ?', "#{text.first}%").where.not(text: text)
    w = where('text LIKE ?', "#{text.first}%")

    # Para nao repetir as palavras.
    w = w.where('text NOT IN (?)', exclude_texts)

    # Filtro por genero.
    w = w.where("info->>'gender' IN (?)", gender) if gender.present?

    # Ordenando aleatoriamente.
    w.order('random()').last
  end

  # Textos diferentes, iniciando com letra diferente.
  def self.different(text:, exclude_texts:)
    # Palavras que iniciam com a mesma letra.
    w = where('text NOT LIKE ?', "#{text.first}%")

    # Exclui palavras ja usadas.
    w = w.where('text NOT IN (?)', exclude_texts)

    # Ordenando aleatoriamente.
    w.order('random()').last
  end

  def full_text
    [type_i18n, text].join ' - '
  end

  def set_info_data
    return unless text.present?

    self.text = youtube? ? self.text.strip : self.text.strip.upcase
    self.total_letters = text.length

    set_letra_info_data if letra?

    # Necessario aqui por causa dos textos recebidos por parametro.
    set_silaba_substantivo_info_data if silaba? || substantivo_proprio? || substantivo_comum?
  end

  private

  def set_default_type
    self.type ||= self.class.types['input_custom']
  end

  # Seta usuario corrente para cada elemento novo.
  def set_user_to_elements
    elements.each do |e|
      e.user ||= user
      e.text = e.text.upcase
    end
  end

  def validate_uniqueness
    # A palavra pode ser composta.
    # t = (text == ' ' || youtube?) ? text : text.upcase.strip
    #
    # # Uma palavra por tipo.
    # return if Word.where(type: type, text: t).empty?
    #
    # self.errors.add :text, :taken
    #
    # false
  end

  def text_to_file_name
    text.downcase.gsub(' ', '-')
  end

  def set_default_image
    case self.images.length.zero? && type
    when 'substantivo_comum'
      self.images_attributes = [{ remote_url: [ENV['ASSET_HOST'], "images/words/#{type}/#{ENV['LUZ_DO_SABER_AMBIENTE']}/#{text_to_file_name}.png"].join('/') }]
    end
  end

  def set_default_audio
    case self.audios.length.zero? && type
    when 'substantivo_comum', 'silaba', 'letra'
      self.audios_attributes = [{ remote_url: [ENV['ASSET_HOST'], "audios/words/#{type}/#{text_to_file_name}.mp3"].join('/') }]
    when 'frase'
      self.audios_attributes = [{ remote_url: [ENV['ASSET_HOST'], "audios/questions/#{text_to_file_name}.mp3"].join('/') }]
    end
  end
end
