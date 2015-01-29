class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]
  before_action :set_leaves, only: :show
  before_action :set_absences, only: :show

  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

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
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      if Student.exists?(id: params[:id])
        @student = Student.find(params[:id])
      else
        flash[:danger] = 'Student with this id does not exist'
        redirect_to students_path
      end
    end

    def set_leaves
      flash.now[:leaves] = 0
      medical_certificates = MedicalCertificate.find_by_student_id(@student)
      logs = @student.logs.where(flag: false)
      if logs && medical_certificates
        logs.each do |log|
          if log.date.between?(medical_certificates.from, medical_certificates.till)
            flash.now[:leaves] += 2
          end
        end
      end
    end

    def set_absences
      flash.now[:total] = 0
      @absences = @student.absences.joins(:lesson).order("lessons.name")
      set_leaves
      @absences.each do |a|
        flash.now[:total] += a.amount
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:name)
    end
end
