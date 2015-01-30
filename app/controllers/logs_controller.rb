class LogsController < ApplicationController
  before_action :set_log, only: [:show, :edit, :update, :destroy]
  before_action :check_lesson_id


  # GET /logs
  # GET /logs.json
  def index
    logs = Log.includes(:student).where(lesson_id: params[:lesson_id]).order(:date)
    @grid = PivotTable::Grid.new do |g|
      g.source_data = logs
      g.column_name = :date
      g.row_name = :student
      g.value_name = :flag
    end
    @grid.build
    @medical_certificates = MedicalCertificate.all
    # render json: @grid.row_headers
  end

  # GET /logs/1
  # GET /logs/1.json
  def show
  end

  # GET /logs/new
  def new
    @students = Student.all.order(:name)
    @log = Log.new
    #@logs = Array.new(@students.count) {Log.new}
  end

  # GET /logs/1/edit
  def edit
    @students = Student.all.order(:name).to_a
    @log.to_a
  end

  # POST /logs
  # POST /logs.json
  def create
    log_params[:flag].each do |key, value|
      @log = Log.new
      @log.student_id = key.to_i
      @log.flag = value
      @log.lesson_id = log_params[:lesson_id].to_i
      @log.date = log_params[:date]
      @log.save
    end

    redirect_to lesson_logs_path, flash: {success: 'Log was successfully created.' }
  end

  # PATCH/PUT /logs/1
  # PATCH/PUT /logs/1.json
  def update
    # render json: log_params
    index = 0
    log_params[:flag].each do |key, value|
      @log[index].student_id = key.to_i
      @log[index].flag = value
      @log[index].lesson_id = log_params[:lesson_id].to_i
      @log[index].date = log_params[:date]
      @log[index].save
      index+=1
    end
    # render json: @log
    redirect_to lesson_logs_path, flash: {success: 'Log was successfully updated.' }
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log.each do |log|
      log.destroy
    end
    respond_to do |format|
      format.html { redirect_to lesson_logs_path, flash: {success: 'Log was successfully destroyed.' }}
      format.json { head :no_content }
    end
  end

  private
    def check_lesson_id(id = params[:lesson_id])
      unless Lesson.exists?(id: id)
        flash[:danger] = 'Lesson with this id does not exist'
        redirect_to controller: :lessons, action: :index
      end
    end

  # Use callbacks to share common setup or constraints between actions.
    def set_log
      @log = Log.joins(:student).where(lesson_id: params[:lesson_id], date: params[:date]).order("students.name")
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def log_params
      params.require(:log).permit(:lesson_id, :date, flag: params[:log][:flag].try(:keys))
    end
end
