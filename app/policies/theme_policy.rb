class ThemePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user && user.role
      when 'admin'
        scope.all
      else
        scope.active
      end
    end
  end

  def manage?
    user.admin? ||
      user.professor?
  end
end
