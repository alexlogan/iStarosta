class StudentsController < ApplicationController
  before_action :set_group
  load_and_authorize_resource :through => :group
  before_action :set_leaves, only: :show
  before_action :set_absences, only: :show

  rescue_from ActiveRecord::RecordNotFound do |exception|
      redirect_to group_students_path(@group), :alert => %Q(Couldn't find Student with this 'id')
  end

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
    # @student = @group.students.build
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    # @student = @group.students.build(student_params)

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
    # byebug
    # authorize!(params[:action], @student || Student)
    @student.destroy
    # if can? :destroy, Student
    #   redirect_to students_path, alert: 'Yaaa'
    # end
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_student
      if Student.exists?(id: params[:id])
        @student = Student.find(params[:id])
      else
        redirect_to students_path, alert: 'Student with this id does not exist'
      end
    end

    def set_group
      if session[:group_id].blank?
        @group = Student.find(params[:id]).group
        session[:group_id] = @group.id
      else
        @group = Group.find(session[:group_id])
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
