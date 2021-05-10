# Alunos.
class Student < User
  default_scope { where role: roles[:student] }

  enum school_period: { morning: 0,
                      afternoon: 1,
                          night: 2 }

  validates :state, :city, :school_year, :school_name, :school_group_code, :school_period, presence: true

  before_validation :set_group_code
  before_create :set_student_code

  private

  def set_group_code
    self.group_code = school_group_code
  end

  # Código de 6 dígitos
  # => Dois primeiros caracteres sigla do estado
  # => 3o digito eh o ano
  # => Demais seguindo uma sequencia (AAA, AAB, AAC)
  def set_student_code
    last_student_code = self.class.last.try(:school_student_code)
    next_letters = if last_student_code
                    last_student_code.last(3).next
                   else
                     'AAA'
                   end

    self.school_student_code = [state, school_year, next_letters].join('').upcase
  end
end
