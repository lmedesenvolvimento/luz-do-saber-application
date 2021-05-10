# Salva o estado da aplicacao de um aluno.
class Game::UserGamesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  before_action :set_student, only: :me

  def create
    @user_game = UserGame.new(user_game_params)

    last_user_games = UserGame.select("id, unique_session_id").order(id: :desc).limit(20).to_a
    user_game = last_user_games.find { |l| l.unique_session_id == user_game_params['unique_session_id'] }

    if(user_game.present?)
      @user_game_update = UserGame.find(user_game['id'])
      @user_game_update.game = user_game_params['game']

      if @user_game_update.save
        render json: { success: true }
      else
        render json: { success: false }, status: :unprocessable_entity
      end
    else
      @user_game = UserGame.new(user_game_params)
      if @user_game.save
        render json: { success: true }
      else
        render json: { success: false }, status: :unprocessable_entity
      end
    end
  end

  def me
  end

  private

  def user_game_params
    params.require(:user_game).permit(:unique_session_id, :name, game: {})
  end

  def set_student
    @student = Student.find_by('lower(school_student_code) = lower(?)', params[:code])
    @group = Group.find_by('lower(code) = lower(?)', @student.school_group_code)
  end
end
