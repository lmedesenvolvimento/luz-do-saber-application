# Modulos do sistema
class Game::ModulosController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @modulos = policy_scope(Modulo).order(:order)
  end

  def all
    @modulos = policy_scope(Modulo).includes(themes: { units: :questions }).order(:order)
  end
end
