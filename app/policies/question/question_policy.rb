class Question::QuestionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case user && user.role
      when 'admin'
        scope
      when 'professor'
        user.questions
      else
        scope.published
      end
    end
  end

  def manage?
    user.admin?
  end
end
