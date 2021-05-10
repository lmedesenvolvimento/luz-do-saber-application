class Question::DescriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_question_description, only: [:show, :edit, :update, :destroy]

  # GET /question/descriptions
  def index
    @q = Question::Description.ransack(params[:q])
    respond_to do |format|
      format.html { @descriptions = @q.result.order(:text).page(params[:page]) }
      format.json { @descriptions = @q.result.order(:text) }
    end
  end

  # GET /question/descriptions/1
  def show
  end

  # GET /question/descriptions/new
  def new
    @description = Question::Description.new
  end

  # GET /question/descriptions/1/edit
  def edit
  end

  # POST /question/descriptions
  def create
    @description = Question::Description.new(question_description_params)


    respond_to do |format|
      if @description.save
        format.json { render json: @description }
        format.html { redirect_to @description, notice: t('helpers.submit.saved') }
      else
        respond_to do |format|
          format.json { render json: { errors: @description.errors } }
          format.html { render :new }
        end
      end
    end
  end

  # PATCH/PUT /question/descriptions/1
  def update
    if @description.update(question_description_params)
      redirect_to @description, notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /question/descriptions/1
  def destroy
    @description.destroy
    redirect_to question_descriptions_url, notice: t('helpers.submit.saved')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question_description
    @description = Question::Description.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def question_description_params
    params.require(:question_description).permit(:question_question_id, :type, :text, :image, :audio)
  end
end
