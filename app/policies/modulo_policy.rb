class ModuloPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:themes).where(themes: { status: :active }).distinct
    end
  end
end
