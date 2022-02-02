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
  attr_accessor :user_school_student_code

  before_validation :set_user, if: -> { user_school_student_code.present? }

  private

  def set_user
    unless self.user = User.find_by(school_student_code: user_school_student_code)
      self.errors.add :user_school_student_code, 'Código não encontrado.'
    end
  end
end
