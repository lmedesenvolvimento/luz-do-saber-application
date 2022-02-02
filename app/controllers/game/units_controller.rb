# Unidades de um tema.
class Game::UnitsController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_theme, only: :index

  def index
    @units = policy_scope(@theme.units).order(:order)
  end

  private

  def set_theme
    @modulo = Modulo.friendly.find(params[:modulo_slug])
    @target_audience = ThemeAudience.friendly.find(params[:target_audience_slug])
    @theme = Theme.where(:theme_audience_id => @target_audience).friendly.find(params[:theme_slug])
  end
end
