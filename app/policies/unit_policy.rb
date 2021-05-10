class UnitPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def manage?
    user.admin? ||
      user.professor?
  end
end
