class GroupsParticipantsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_group
  before_action :set_groups_participant, only: [:show, :edit, :update, :destroy]

  # GET /groups_participants
  def index
    @groups_participants = policy_scope(@group.participants).page(params[:page])
  end

  # GET /groups_participants/1
  def show
  end

  # GET /groups_participants/new
  def new
    @groups_participant = @group.participants.new
  end

  # GET /groups_participants/1/edit
  def edit
    @groups_participant.user_email = @groups_participant.user.email
  end

  # POST /groups_participants
  def create

    @groups_participant = @group.participants.new(groups_participant_params)
    if @groups_participant.save
      respond_to do |format|
        format.json { render json: @groups_participant }
        format.html { redirect_to group_participants_url(@group), notice: t('helpers.submit.saved') }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @groups_participant.errors } }
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /groups_participants/1
  def update
    if @groups_participant.update(groups_participant_params)
      respond_to do |format|
        format.json { render json: @groups_participant }
        format.html { redirect_to group_participants_url(@group), notice: t('helpers.submit.saved')}
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @groups_participant.errors } }
        format.html { render :edit }
      end
    end
  end

  # DELETE /groups_participants/1
  def destroy
    @groups_participant.destroy
      respond_to do |format|
        format.json { render json: @groups_participant }
        format.html { redirect_to group_participants_url(@group), notice: t('helpers.submit.destroyed') }
      end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_groups_participant
    @groups_participant = @group.participants.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def groups_participant_params
    params.require(:groups_participant).permit(:type,
                                                :user_school_student_code,
                                                :status)
  end
end
