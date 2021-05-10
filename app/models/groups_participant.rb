class GroupsParticipant < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: {
    student: 0,
    professor: 1
  }

  enum status: {
    active: 0,
    inactive: 1
  }

  belongs_to :user
  belongs_to :group

  validates :user, :group, presence: true

  attr_accessor :user_email

  before_validation :set_user, if: -> { user_email.present? }

  private

  def set_user
    unless self.user = User.find_by(email: user_email)
      self.errors.add :user_email, 'Email não encontrado.'
    end
  end
end
