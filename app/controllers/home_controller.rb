class HomeController < ApplicationController
  def index
    case current_user && current_user.role
    when 'admin' then redirect_to admin_users_url
    when 'professor' then redirect_to professor_students_url
    # when 'student' then redirect_to question_questions_url
    end
  end
end
