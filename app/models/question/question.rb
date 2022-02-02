# Atividades.
# As atividades podem receber um parametro externo. Este parametro define como os itens serao gerados.
# Ex.: Na atividade de cracha a atividade espera que o usuario entre com o nome.
class Question::Question < ApplicationRecord
  enum status: { draft: 0,
             published: 1,
              archived: 2 }

  # Tipo de parametro externo que a atividade espera.
  # Devem ser os mesmos parametros do model Word.
  enum external_param_type: { substantivo_proprio: 2,
                                substantivo_comum: 3,
                                           nenhum: 99 }, _prefix: :external_param

  belongs_to :template, foreign_key: :question_question_template_id, class_name: 'Question::QuestionTemplate', optional: true

  belongs_to :type, foreign_key: :question_type_id
  belongs_to :subtype, foreign_key: :question_subtype_id
  belongs_to :user
  belongs_to :unit

  has_one :theme, through: :unit
  has_one :modulo, through: :theme

  has_one :title, foreign_key: :question_question_id, inverse_of: :question, dependent: :destroy

  has_many :questions_descriptions, foreign_key: :question_question_id, dependent: :destroy
  has_many :descriptions, through: :questions_descriptions

  # Como a atividade eh pontuada.
  has_many :pointings, foreign_key: :question_question_id, inverse_of: :question, dependent: :destroy

  # Ligacao de templates de itens a questoes.
  has_many :questions_item_templates, foreign_key: :question_question_id, inverse_of: :question, dependent: :destroy

  # Templates de itens.
  has_many :item_templates, through: :questions_item_templates

  # Ligacao de itens a atividades
  has_many :items, foreign_key: :question_question_id, class_name: 'QuestionsItem', dependent: :destroy
  has_many :words, through: :items

  has_many :questions_groups, foreign_key: :question_question_id
  has_many :groups, through: :questions_groups

  accepts_nested_attributes_for :title
  # accepts_nested_attributes_for :description

  accepts_nested_attributes_for :questions_item_templates
  accepts_nested_attributes_for :items, reject_if: proc { |a| a['type'].blank? }, allow_destroy: true
  accepts_nested_attributes_for :pointings

  before_save :set_description, if: -> { description_text.present? }
  before_save :set_subtitle, if: -> { subtitle.present? }
  before_save :set_group, if: -> { group_code.present? }

  validates :total_correct_items, :order, presence: true
  validates_uniqueness_of :order, scope: :unit

  after_initialize :load_question_template, if: -> { new_record? && template.present? }

  before_save :load_question_template_for_update, if: -> { !new_record? && template.present? }

  attr_accessor :description_text, :group_code

  def self.by_group(group_code)
    return self unless group_code.present?

    joins(:user).
    joins('LEFT JOIN question_questions_groups  AS qg ON qg.question_question_id = question_questions.id').
    joins('LEFT JOIN groups                     AS g  ON g.id = qg.group_id').
    where('(users.role = 2 OR LOWER(g.code) = LOWER(?))', group_code)
  end

  # def destroy
  #   self.archived!
  # end

  def load_question_template_for_update
    # alterando apenas o que tem erro; os demais continuam inalterados
    case template.slug
    when 
        'encaixe-de-letra',
        'charada-de-letras'                  
          then duplica_item_key_como_item_value('letra')
    when 
        'palavra-secreta',
        'complete-a-palavra-com-letra'       
            then quebra_palavra_em_letras
    when 'desembaralhe-seu-nome'              
      then quebra_palavra_em_letras_value
    when 
        'decomposicao-da-palavra-geradora',
        'separacao-silabica',
        'formacao-de-palavras',
        'monte-a-palavra-com-silabas'        
            then quebra_palavra_em_silabas
    when
        'ligacao-texto-imagem',
        'jogo-da-memoria-palavra-imagem',
        'jogo-da-memoria-imagem-imagem',
        'escreva-a-palavra',
        'segredo-das-palavras',
        'caca-palavras'
        then
            #para criar values de itens adicionados na alteracao
            duplica_item_key_como_item_value
    end
  end

  def set_description
    self.descriptions << Question::Description.find_or_create_by(text: description_text.upcase)
  end

  def set_subtitle
    # push no array com o subtitle
    self.descriptions << Question::Description.find_or_create_by(text: subtitle.upcase)
  end

  def set_group
    self.groups << Group.find_by(code: group_code.upcase)
  end

  def used_texts
    texts = words.map(&:text)

    # Se nenhuma palavra foi usada ainda
    # eh necessario passar um texto vazio pra consultar pra nao comparar com NULL.
    texts = [''] if texts.empty?

    texts
  end

  def load_question_template
    self.type ||= Question::Type.friendly.find(template.question_type)
    self.subtype ||= Question::Subtype.friendly.find(template.question_subtype)

    self.total_correct_items ||= template.question_total_correct_items

    self.shuffle_key_items ||= template.question_shuffle_keys
    self.shuffle_value_items ||= template.question_shuffle_values

    # TODO: deixar apenas o description como outra tabela.
    self.title_attributes= { "text": template.question_title } unless title.present?
    self.description_text = template.question_description unless description_text.present?

    self.external_param_type = template.question_external_param_type
    self.external_param_total = template.question_external_param_total

    self.pointings_attributes= [
      {
        "type": "lost_a_star_by_attempt",
        "quantity": template.points_lost_a_star_by_attempt
      },
      {
        "type": "lost_a_star_by_time",
        "quantity": template.points_lost_a_star_by_time
      }
    ]

    self.questions_item_templates_attributes= [
      {
        "type": "key",
        "font_size": template.item_template_key_font_size,
        "custom": template.item_template_key_custom,
        "tags": template.item_template_key_tags,
        "total_per_line": template.item_template_key_total_per_line,
        "question_item_template_id": Question::ItemTemplate.find_by(slug: template.item_template_key_template_slug).try(:id),
        "custom_image_url": item_template_custom_image
      },
      {
        "type": "value",
        "font_size": template.item_template_value_font_size,
        "custom": template.item_template_value_custom,
        "tags": template.item_template_value_tags,
        "total_per_line": template.item_template_value_total_per_line,
        "question_item_template_id": Question::ItemTemplate.find_by(slug: template.item_template_value_template_slug).try(:id)
      }
    ]

    case template.slug
    when 'decomposicao-da-palavra-geradora',
         'separacao-silabica',
         'formacao-de-palavras',
         'monte-a-palavra-com-silabas'        then quebra_palavra_em_silabas
    when 'ditado-de-frases-escrever',
         'monte-a-frase-arrastar'             then quebra_frases_em_palavras
    # when 'descubra-a-letra-faltante-encaixar' then descubra_a_letra_faltante
    when 'encaixe-de-letra',
         'charada-de-letras'                  then duplica_item_key_como_item_value('letra')
    when 'ligacao-texto-imagem',
          'jogo-da-memoria-palavra-imagem',
          'jogo-da-memoria-imagem-imagem',
          'escreva-a-palavra',
          'segredo-das-palavras',
          'caca-palavras',
          'ortografia',
          'bingo-de-palavras',
          'alternativa-audio-x'               then duplica_item_key_como_item_value
    when 'palavra-secreta',
         'complete-a-palavra',
         'complete-a-palavra-com-letra'       then quebra_palavra_em_letras
    when 'desembaralhe-seu-nome'              
      then quebra_palavra_em_letras_value
    when 'quantidade-de-letras',
         'quantidade-de-silabas'              then quantidade_de_letras_ou_silabas
    when 'tipos-de-letras-conjuntos'          then tipos_de_letras_conjuntos
    end
  end

  def tipos_de_letras_conjuntos
    self.items.each do |item|
      next unless item.type == 'key'

      item.value_items_attributes= [
        {
          "type": "value",
          "word_type": "letra",
          "word_source_type": "key_different"
        }
      ]
    end
  end

  def quantidade_de_letras_ou_silabas
    self.items.first.value_items_attributes= [
      {
        "type": "value",
        "word_type": "numero",
        "word_source_type": "key_same"
      }
    ]
  end

  def item_template_custom_image
    case template.slug
    when 'caixa-de-palavras'
      ENV['ASSET_HOST'] + '/images/questions/fundamental/custom/caixa.png'
    when 'meu-cracha'
      ENV['ASSET_HOST'] + '/images/questions/fundamental/custom/cracha.png'
    end
  end

  def quebra_palavra_em_letras
    self.items.first.value_items_attributes= items.first.word.text.split('').map do |w|
      # next unless w.present?

      {
        "type": "value",
        "word_type": "letra",
        "word_source_type": "key_same"
      }
    end
  end

  def quebra_palavra_em_letras_value
    self.items.each do |item|
      next unless item.type == 'key'
      item.value_items_attributes= item.word.text.split('').map do |letra|
        {
          "type": "value",
          "word_type": "letra",
          "word_text": letra
        }
      end
    end
  end

  def duplica_item_key_como_item_value(type = nil)
    self.items.each do |item|
      next unless item.type == 'key'

      item.value_items_attributes= [
        {
          "type": "value",
          "word_type": type || item.word_type,
          "word_source_type": "key_same",
          "remote_image_url": item.remote_image_url,
          "remote_audio_url": item.remote_audio_url
        }
      ]
    end
  end

  def quebra_frases_em_palavras
    self.items.first.value_items_attributes= items.first.word.text.split(' ').map do |w|
      {
        "type": "value",
        "word_type": (w.length < 2 ? 'letra' : (w.length < 4 ? 'silaba' : 'substantivo_comum')),
        "word_source_type": "key_same"
      }
    end
  end

  def quebra_palavra_em_silabas
    self.items.each do |item|
      next unless item.type == 'key'

      item.value_items_attributes= item.word.silabas.map do |silaba|
        {
          "type": "value",
          "word_type": "silaba",
          "word_text": silaba.text
        }
      end
    end
  end
end
