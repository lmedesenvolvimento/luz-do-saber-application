class Game::TargetAudiencesController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :set_modulo, only: :index

  def index

    @theme_audiences = @modulo.theme_audiences
    # raise "#{@theme_audiences.to_json}"
  end

  def set_modulo
    @modulo = Modulo.friendly.find(params[:modulo_slug])
  end
end
