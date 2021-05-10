# Templates/Componentes dos itens.
# Indica qual componente deve ser usado para exibir os itens de uma atividade.
class Question::ItemTemplate < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  self.inheritance_column = :_type_disabled

  # Que tipo de componente deve ser utilizado.
  enum type: { texto: 0,
              imagem: 1,
               audio: 2,
               video: 3,
             youtube: 4 }

  has_many :questions_item_templates, foreign_key: :question_item_template_id
  has_many :questions, through: :questions_item_templates

  has_attached_file :image #, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  include DeletableAttachment

  validates :name, presence: true
end
