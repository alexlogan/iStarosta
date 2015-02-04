class MedicalCertificatesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_student
  before_action :set_medical_certificate, only: [:show, :edit, :update, :destroy]

  # GET /medical_certificates
  # GET /medical_certificates.json
  def index
    @medical_certificates = @student.medical_certificates
  end

  # GET /medical_certificates/1
  # GET /medical_certificates/1.json
  def show
  end

  # GET /medical_certificates/new
  def new
    @medical_certificate = @student.medical_certificates.new
  end

  # GET /medical_certificates/1/edit
  def edit
  end

  # POST /medical_certificates
  # POST /medical_certificates.json
  def create
    @medical_certificate = @student.medical_certificates.new(medical_certificate_params)

    respond_to do |format|
      if @medical_certificate.save
        format.html { redirect_to student_medical_certificates_path(@student), flash: {success: 'Medical certificate was successfully created.'} }
        format.json { render :show, status: :created, location: @medical_certificate }
      else
        format.html { render :new }
        format.json { render json: @medical_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /medical_certificates/1
  # PATCH/PUT /medical_certificates/1.json
  def update
    respond_to do |format|
      if @medical_certificate.update(medical_certificate_params)
        format.html { redirect_to [@student, @medical_certificate], flash: {success: 'Medical certificate was successfully updated.'} }
        format.json { render :show, status: :ok, location: @medical_certificate }
      else
        format.html { render :edit }
        format.json { render json: @medical_certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /medical_certificates/1
  # DELETE /medical_certificates/1.json
  def destroy
    @medical_certificate.destroy
    respond_to do |format|
      format.html { redirect_to student_medical_certificates_path(@student), flash: {success: 'Medical certificate was successfully destroyed.'} }
      format.json { head :no_content }
    end
  end

  private
    def set_student
      if Student.exists?(id: params[:student_id])
        @student = Student.find(params[:student_id])
      else
        flash[:danger] = 'Student with this id does not exist'
        redirect_to students_path
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
