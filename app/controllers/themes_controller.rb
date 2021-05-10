class ThemesController < ApplicationController
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  before_action do
    authorize Theme, :manage?
  end

  # GET /themes
  def index
    @q = policy_scope(Theme).ransack(params[:q])
    @themes = @q.result.order(:order)
  end

  # GET /themes/1
  def show
  end

  # GET /themes/new
  def new
    @theme = Theme.new order: Theme.next_order
  end

  # GET /themes/1/edit
  def edit
  end

  # POST /themes
  def create
    @theme = Theme.new(theme_params)
    @theme.user = current_user

    if @theme.save
      redirect_to @theme, notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /themes/1
  def update
    if @theme.update(theme_params)
      redirect_to @theme, notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /themes/1
  def destroy
    if @theme.destroy
      redirect_to themes_url, notice: t('helpers.submit.destroyed')
    else
      redirect_to theme_path(@theme), alert: @theme.errors.full_messages.join(',')
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_theme
    @theme = Theme.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def theme_params
    params.require(:theme).permit(:modulo_id,
                                  :status,
                                  :title,
                                  :description,
                                  :order,
                                  :target_audience,
                                  :theme_audience_id,
                                  :cover)
  end
end
