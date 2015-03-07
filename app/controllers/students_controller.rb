class StudentsController < ApplicationController
  before_action :check_group_id, if: Proc.new { params[:group_id] }
  before_action :check_student_id, if: Proc.new { params[:id] }
  before_action :set_group
  load_and_authorize_resource :through => :group

  # GET /students
  # GET /students.json
  def index
    @students = @students.order(:name)
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    respond_to do |format|
      if @student.save
        format.html { redirect_to  @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.'}
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def check_group_id
      redirect_to groups_path, alert: %Q(Couldn't find Group with this 'id') unless Group.exists?(params[:group_id])
    end

    def check_student_id
      redirect_to groups_path, alert: %Q(Couldn't find Student with this 'id') unless Student.exists?(params[:id])
    end


  def set_group
    if action_name == 'index'
      @group = (Group.find(params[:group_id]) if params[:group_id]) || current_user.try(:group) || raise(CanCan::AccessDenied)
    else
      @group = (Student.find(params[:id]).group if params[:id]) || current_user.try(:group)
    end
  end



    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name)
    end
end
