# Temas de um modulo.
class Game::ThemesController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_modulo, only: :index

  def index
    @themes = policy_scope(@modulo.themes).order(:order)
  end

  private

  def set_modulo
    @modulo = Modulo.friendly.find(params[:modulo_slug])
  end
end
