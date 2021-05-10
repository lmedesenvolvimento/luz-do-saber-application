class Question::ItemTemplatesController < ApplicationController
  before_action :set_question_item_template, only: [:show, :edit, :update, :destroy]

  # GET /question/item_templates
  def index
    @item_templates = Question::ItemTemplate.all
  end

  # GET /question/item_templates/1
  def show
  end

  # GET /question/item_templates/new
  def new
    @item_template = Question::ItemTemplate.new
  end

  # GET /question/item_templates/1/edit
  def edit
  end

  # POST /question/item_templates
  def create
    @item_template = Question::ItemTemplate.new(question_item_template_params)

    if @item_template.save
      redirect_to @item_template, notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /question/item_templates/1
  def update
    if @item_template.update(question_item_template_params)
      redirect_to @item_template, notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /question/item_templates/1
  def destroy
    @item_template.destroy
    redirect_to question_item_templates_url, notice: t('helpers.submit.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question_item_template
    @item_template = Question::ItemTemplate.friendly.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def question_item_template_params
    params.require(:question_item_template).permit(:type,
                                                   :name,
                                                   :description,
                                                   :total_per_line,
                                                   :image,
                                                   :delete_image)
  end
end
