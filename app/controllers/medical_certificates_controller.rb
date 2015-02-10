class MedicalCertificatesController < ApplicationController
  load_and_authorize_resource :student
  load_and_authorize_resource :through => :student

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to group_students_path(@group), :alert => %Q(Couldn't find Lesson with this 'id')
  end

  # GET students/:id/medical_certificates
  # GET students/:id/medical_certificates.json
  def index
    @medical_certificates = @medical_certificates.order(:from)
  end

  # GET students/:id/medical_certificates/1
  # GET students/:id/medical_certificates/1.json
  def show
  end

  # GET students/:id/medical_certificates/new
  def new
  end

  # GET students/:id/medical_certificates/1/edit
  def edit
  end

  # POST students/:id/medical_certificates
  # POST students/:id/medical_certificates.json
  def create
    respond_to do |format|
      if @medical_certificate.save
        format.html { redirect_to student_medical_certificates_path(@student), notice: 'Medical certificate was successfully created.'}
        format.json { render :show, status: :created, location: @medical_certificate }
      else
        format.html { render :new }
        format.json { render json: @medical_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT students/:id/medical_certificates/1
  # PATCH/PUT students/:id/medical_certificates/1.json
  def update
    respond_to do |format|
      if @medical_certificate.update(medical_certificate_params)
        format.html { redirect_to student_medical_certificates_path(@student), notice: 'Medical certificate was successfully updated.'}
        format.json { render :show, status: :ok, location: @medical_certificate }
      else
        format.html { render :edit }
        format.json { render json: @medical_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE students/:id/medical_certificates/1
  # DELETE students/:id/medical_certificates/1.json
  def destroy
    @medical_certificate.destroy
    respond_to do |format|
      format.html { redirect_to student_medical_certificates_path(@student), notice: 'Medical certificate was successfully destroyed.'}
      format.json { head :no_content }
    end
  end

  private
    def set_student
      if Student.exists?(id: params[:student_id])
        @student = Student.find(params[:student_id])
      else
        redirect_to students_path, alert: 'Student with this id does not exist'
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_medical_certificate
      @medical_certificate = @student.medical_certificates.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medical_certificate_params
      params.require(:medical_certificate).permit(:from, :till)
    end
end
