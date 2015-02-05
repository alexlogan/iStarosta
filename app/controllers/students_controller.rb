class StudentsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_group
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :set_leaves, only: :show
  before_action :set_absences, only: :show

  # GET /students
  # GET /students.json
  def index
    @students = @group.students.all.order(:name)
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = @group.students.build
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = @group.students.build(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, flash: {success: 'Student was successfully created.'} }
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
        format.html { redirect_to @student, flash: {success: 'Student was successfully updated.'} }
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
      format.html { redirect_to students_url, flash: {success: 'Student was successfully destroyed.' }}
      format.json { head :no_content }
    end
  end

  private
    def set_group
      if session[:group_id].blank?
        redirect_to groups_path, flash: {danger: 'Select group at fist.' }
      else
        @group = Group.find(session[:group_id])
      end
    end

  # Use callbacks to share common setup or constraints between actions.
    def set_student
      if @group.students.exists?(id: params[:id])
        @student = @group.students.find(params[:id])
      else
        flash[:danger] = 'Student with this id does not exist'
        redirect_to students_path
      end
    end

    def set_leaves
      flash.now[:leaves] = 0
      medical_certificates = @student.medical_certificates.all
      logs = @student.logs.where(flag: false)
      if logs.any? && medical_certificates.any?
        logs.each do |log|
          medical_certificates.each do |mc|
            flash.now[:leaves] += 2 if log.date.between?(mc.from, mc.till)
          end
        end
      end
    end

    def set_absences
      flash.now[:total] = 0
      @absences = @student.absences.joins(:lesson).order("lessons.name")
      @absences.each do |a|
        flash.now[:total] += a.amount
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name)
    end
end
