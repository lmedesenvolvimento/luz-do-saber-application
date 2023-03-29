class ModulosController < ApplicationController
  before_action :set_modulo, only: [:show, :edit, :update]

  def index
    @modulos = policy_scope(Modulo).order(:order)
  end

  def show
  end

  # GET /theme_audiences/1/edit
  def edit
  end

  # GET /theme_audiences/new
  def new
    @modulo = Modulo.new
  end

  # POST /theme_audiences
  # POST /theme_audiences.json
  def create
    @modulo = Modulo.new(modulo_params)

    respond_to do |format|
      if @modulo.save
        format.html { redirect_to @modulo, notice: 'Modulo was successfully created.' }
        format.json { render :show, status: :created, location: @modulo }
      else
        format.html { render :new }
        format.json { render json: @modulo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /theme_audiences/1
  # PATCH/PUT /theme_audiences/1.json
  def update
    respond_to do |format|
      if @modulo.update(modulo_params)
        format.html { redirect_to @modulo, notice: 'Modulo was successfully updated.' }
        format.json { render :show, status: :ok, location: @modulo }
      else
        format.html { render :edit }
        format.json { render json: @modulo.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_modulo
      @modulo = Modulo.friendly.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def modulo_params
      params.require(:modulo).permit(:title, :description, :cover, :status, :order, :color)
    end
end