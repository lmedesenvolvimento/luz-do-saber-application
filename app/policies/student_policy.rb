class StudentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user && user.role
      when 'admin'
        scope.all
      when 'professor'
        # alunos das turmas desse professor
        professor_groups = user.groups.pluck(:code)
        scope.where(school_group_code: professor_groups)
      else
        scope.none
      end
    end
  end

  def manage?
    user.admin? || user.professor?
  end
end
