class GroupPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user && user.role
      when 'admin'
        scope.all
      when 'professor'
        # turmas desse professor
        scope = user.groups
      else
        scope.none
      end
    end
  end

  def manage?
    user.admin? ||
      user.professor?
  end
end
