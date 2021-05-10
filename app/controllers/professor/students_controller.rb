class Professor::StudentsController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action do
    authorize Student, :manage?
  end

  # GET /users
  def index
    @students = policy_scope(Student).order(:first_name)
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @groups = current_user.groups
    @student = Student.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @student = Student.new(user_params)

    if @student.save
      redirect_to [:professor, @student], notice: t('helpers.submit.saved')
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if @student.update(user_params)
      redirect_to [:professor, @student], notice: t('helpers.submit.saved')
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @student.destroy
    redirect_to professor_students_url, notice: t('helpers.submit.destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @student = Student.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def user_params
    # raise "#{params}"
    params.require(:student).permit(:first_name,
                                    :last_name,
                                    :email,
                                    :password,
                                    :role,
                                    :status,
                                    :group_code,
                                    :birthdate,
                                    :mother,
                                    :state,
                                    :city,
                                    :school_name,
                                    :school_year,
                                    :school_period,
                                    :school_group_code,
                                    :school_student_code,
                                  )
  end
end
