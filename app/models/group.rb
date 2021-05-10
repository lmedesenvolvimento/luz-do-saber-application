# Turmas.
class Group < ApplicationRecord
  belongs_to :user

  has_many :participants, class_name: 'GroupsParticipant'
  has_many :questions_groups, class_name: 'Question::QuestionsGroup'
  has_many :questions, through: :questions_groups

  before_validation :set_code, on: :create

  after_create :set_professor, if: -> { user.professor? }

  validates :user, :name, :code, presence: true

  validates_uniqueness_of :code

  def label
    [self.code, self.name].join(' - ')
  end

  private



  def set_professor
    self.participants.professor.active.create user_id: user_id
  end

  def set_code
    self.code = SecureRandom.hex(2).upcase
  end
end
