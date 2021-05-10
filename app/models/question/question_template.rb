# Template de uma atividade.
class Question::QuestionTemplate < ApplicationRecord
  self.inheritance_column = :_type_disabled

  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :user

  has_attached_file :image #, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  include DeletableAttachment
end
