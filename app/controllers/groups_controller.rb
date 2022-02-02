class GroupsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  before_action do
    authorize Group, :manage?
  end

  # GET /groups
  def index
    @q = policy_scope(Group).ransack(params[:q])
    @groups = @q.result.order(:name).page(params[:page])
  end

  # GET /groups/1
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      respond_to do |format|
        format.json { render json: @group }
        format.html { redirect_to @group, notice: t('helpers.submit.saved') }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @group.errors } }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      respond_to do |format|
        format.json { render json: @group }
        format.html { redirect_to @group, notice: t('helpers.submit.saved') }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @group.errors } }
        format.html { render :edit }
      end
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy
      respond_to do |format|
        format.json { render json: @group }
        format.html { redirect_to groups_url, notice: t('helpers.submit.destroyed') }
      end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_params
    params.require(:group).permit(:code, :name, :description)
  end
end
