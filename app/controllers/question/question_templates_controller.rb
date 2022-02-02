class Question::QuestionTemplatesController < ApplicationController
  before_action :set_question_template, only: [:show, :edit, :update, :destroy]

  # GET /question/question_templates
  # GET /question/question_templates.json
  def index
    @question_templates = Question::QuestionTemplate.order(:name)
  end

  def list
    @question_templates = Question::QuestionTemplate.order(:name)
  end

  # GET /question/question_templates/1
  # GET /question/question_templates/1.json
  def show
  end

  # GET /question/question_templates/new
  def new
    @question_template = Question::QuestionTemplate.new
  end

  # GET /question/question_templates/1/edit
  def edit
  end

  # POST /question/question_templates
  # POST /question/question_templates.json
  def create
    @question_template = Question::QuestionTemplate.new(question_question_template_params)

    if @question_template.save
      redirect_to question_template_url(@question_template), notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /question/question_templates/1
  # PATCH/PUT /question/question_templates/1.json
  def update
    if @question_template.update(question_question_template_params)
      redirect_to question_template_url(@question_template), notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /question/question_templates/1
  # DELETE /question/question_templates/1.json
  def destroy
    @question_template.destroy

    redirect_to question_templates_url, notice: t('helpers.submit.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_question_template
    @question_template = Question::QuestionTemplate.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def question_question_template_params
    params.require(:question_question_template).permit(:name,
                                                        :image,
                                                        :question_type,
                                                        :question_subtype,
                                                        :question_description,
                                                        :question_title,

                                                        :question_external_param_type,
                                                        :question_external_param_total,

                                                        :question_total_correct_items,
                                                        :question_shuffle_keys,
                                                        :question_shuffle_values,

                                                        :points_lost_a_star_by_attempt,
                                                        :points_lost_a_star_by_time,

                                                        :item_template_key_font_size,
                                                        :item_template_key_custom,
                                                        :item_template_key_tags,
                                                        :item_template_key_total_per_line,
                                                        :item_template_key_template_slug,
                                                        :item_template_value_font_size,
                                                        :item_template_value_custom,
                                                        :item_template_value_tags,
                                                        :item_template_value_total_per_line,
                                                        :item_template_value_template_slug)
  end
end
