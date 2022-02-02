class UnitsController < ApplicationController
  before_action :set_theme
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  before_action do
    authorize Unit, :manage?
  end

  # GET /units
  def index
    @q = policy_scope(@theme.units).ransack(params[:q])
    @units = @q.result.order(:order).page(params[:page])
  end

  # GET /units/1
  def show
  end

  # GET /units/new
  def new
    @unit = @theme.units.new order: Unit.next_order
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  def create
    @unit = @theme.units.new unit_params
    @unit.user = current_user

    if @unit.save
      redirect_to [@theme, @unit], notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /units/1
  def update
    if @unit.update(unit_params)
      redirect_to [@theme, @unit], notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /units/1
  def destroy
    @unit.destroy
    redirect_to theme_units_url(@theme), notice: t('helpers.submit.destroyed')
  end

  private

  def set_theme
    @theme = Theme.friendly.find(params[:theme_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_unit
    @unit = @theme.units.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def unit_params
    params.require(:unit).permit(:theme_id,
                                 :status,
                                 :order,
                                 :title,
                                 :description,
                                 :cover)
  end
end
