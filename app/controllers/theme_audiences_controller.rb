class ThemeAudiencesController < ApplicationController
  before_action :set_theme_audience, only: [:show, :edit, :update, :destroy]

  # GET /theme_audiences
  # GET /theme_audiences.json
  def index
    @theme_audiences = ThemeAudience.all
  end

  # GET /theme_audiences/1
  # GET /theme_audiences/1.json
  def show
  end

  # GET /theme_audiences/new
  def new
    @theme_audience = ThemeAudience.new
  end

  # GET /theme_audiences/1/edit
  def edit
  end

  # POST /theme_audiences
  # POST /theme_audiences.json
  def create
    @theme_audience = ThemeAudience.new(theme_audience_params)

    respond_to do |format|
      if @theme_audience.save
        format.html { redirect_to @theme_audience, notice: 'Theme audience was successfully created.' }
        format.json { render :show, status: :created, location: @theme_audience }
      else
        format.html { render :new }
        format.json { render json: @theme_audience.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /theme_audiences/1
  # PATCH/PUT /theme_audiences/1.json
  def update
    respond_to do |format|
      if @theme_audience.update(theme_audience_params)
        format.html { redirect_to @theme_audience, notice: 'Theme audience was successfully updated.' }
        format.json { render :show, status: :ok, location: @theme_audience }
      else
        format.html { render :edit }
        format.json { render json: @theme_audience.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /theme_audiences/1
  # DELETE /theme_audiences/1.json
  def destroy
    @theme_audience.destroy
    respond_to do |format|
      format.html { redirect_to theme_audiences_url, notice: 'Theme audience was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_theme_audience
      @theme_audience = ThemeAudience.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def theme_audience_params
      params.require(:theme_audience).permit(:title, :description, :cover, :status, :order)
    end
end
