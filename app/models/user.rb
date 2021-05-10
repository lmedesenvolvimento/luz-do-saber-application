class User < ApplicationRecord
  enum role: { student: 0, # Aluno
               professor: 1, # Professor
               admin: 2, # Gerenciador do sistema
             }

  enum status: { active: 0, # perfill ativo: liberado para efetuar login
                 inactive: 1, # perfil inativo: nao pode efetuar login
               }

  enum gender: { female: 0, # feminino
                 male: 1, # masculino
               }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :groups_participants, foreign_key: :user_id
  has_many :groups, through: :groups_participants
  has_many :questions, class_name: 'Question::Question'

  before_validation :set_student_defaults, if: -> { student? }, on: :create

  validates :email, :first_name, :last_name, presence: true
  validates :birthdate, :mother, presence: true, if: -> { student? }

  before_save :set_group, if: -> { group_code.present? }
  after_create :set_group_participant, if: -> { group.present? }

  attr_accessor :group_code, :group

  def name
    "#{first_name} #{last_name}"
  end

  private

  def set_group
    self.group = Group.find_by(code: group_code)
  end

  def set_group_participant
    self.group.participants.create user: self
  end

  def set_student_defaults
    self.email = [SecureRandom.hex(4), '@mail.com'].join
    self.password ||= '123456'
  end
end
