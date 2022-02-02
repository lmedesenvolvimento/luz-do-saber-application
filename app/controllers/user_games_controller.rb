class UserGamesController < ApplicationController
  before_action :set_user_game, only: [:edit, :update, :destroy]
  before_action :set_user_game_for_user, only: [:show]
  before_action :set_user_game_for_code, only: [:get_from_code]

  # GET /user_games
  # GET /user_games.json
  def index
    # @q = UserGame.ransack(params[:q])
    # @user_games = @q.result.order(id: :desc).page(params[:page])
    @user_games = UserGame.order(id: :desc).limit(100).page(params[:page])

  end

  # GET /user_games/1
  # GET /user_games/1.json
  def show
  end

  def get_from_code
    render :json => @user_game
  end

  # GET /user_games/new
  def new
    @user_game = UserGame.new
  end

  # GET /user_games/1/edit
  def edit
  end

  # POST /user_games
  # POST /user_games.json
  def create
    @user_game = UserGame.new(user_game_params)

    respond_to do |format|
      if @user_game.save
        format.html { redirect_to @user_game, notice: t('helpers.submit.saved') }
        format.json { render :show, status: :created, location: @user_game }
      else
        format.html { render :new }
        format.json { render json: @user_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_games/1
  # PATCH/PUT /user_games/1.json
  def update
    respond_to do |format|
      if @user_game.update(user_game_params)
        format.html { redirect_to @user_game, notice: t('helpers.submit.saved') }
        format.json { render :show, status: :ok, location: @user_game }
      else
        format.html { render :edit }
        format.json { render json: @user_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_games/1
  # DELETE /user_games/1.json
  def destroy
    @user_game.destroy
    respond_to do |format|
      format.html { redirect_to user_games_url, notice: t('helpers.submit.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_game
    @user_game = UserGame.find(params[:id])
  end

  def set_user_game_for_code
    @user_game = UserGame.where(code: params[:code]).first
  end

  def set_user_game_for_user
    @user_game = UserGame.where(params[:user_id]).last
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_game_params
    params.require(:user_game).permit(:unique_session_id, :user_id, :name, :code, :game)
  end
end
