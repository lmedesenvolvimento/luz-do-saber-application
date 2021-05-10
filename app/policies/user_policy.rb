class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user && user.role
      when 'admin'
        scope.all
      else
        scope.none
      end
    end
  end

  def manage?
    user.admin?
  end
end
