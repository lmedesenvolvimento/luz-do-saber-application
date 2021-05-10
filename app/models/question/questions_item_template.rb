# Tabela de ligacao entre uma questao e os templates dos itens.

# Informa para a atividade como os itens devem ser exibidos.
# Se o item for do tipo key ou do tipo value, tamanho da fonte, quantos itens por linha, customizacoes, etc.
class Question::QuestionsItemTemplate < ApplicationRecord
  self.inheritance_column = :_type_disabled

  # O template deve ser aplicado
  enum type: { key: 0,
             value: 1 }

  # Indica tamanho da fonte do componente.
  enum font_size: { relative: 0, # Devera ser setado ao renderizar a atividade.
             'extreme-small': 1,
                       small: 2,
                      medium: 3,
                         big: 4 }, _prefix: :font_size

  belongs_to :question, foreign_key: :question_question_id
  belongs_to :item_template, foreign_key: :question_item_template_id, optional: true

  has_attached_file :custom_image #, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :custom_image, content_type: /\Aimage\/.*\z/

  include DeletableAttachment

  def custom_image_full_url
    if custom_image.present?
      [ENV['ASSET_HOST'], custom_image.url].join('/')
    elsif custom_image_url.present?
      custom_image_url
    else; nil
    end
  end
end
