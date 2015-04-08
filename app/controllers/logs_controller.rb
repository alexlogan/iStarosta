class LogsController < ApplicationController
  before_action :check_lesson_id
  load_and_authorize_resource :lesson
  before_action :check_logs_date, if: Proc.new { params[:date] }
  load_and_authorize_resource :through => :lesson
  skip_load_and_authorize_resource :only => :index
  before_action :set_group
  before_action :check_students, only: [:new, :create]
  before_action :set_log, only: [:show, :edit, :update, :destroy]


  # GET /lesson/:id/logs
  # GET /lesson/:id/logs.json
  def index
    @logs = Hash.new
    @logs[:col_headers] = @lesson.logs.select(:date, :transaction_id).distinct.order(:date)
    @logs[:rows] = @group.students.order(:name)
  end

  # GET /lesson/:id/logs/1
  # GET /lesson/:id/logs/1.json
  def show
  end

  # GET /lesson/:id/logs/new
  def new
    @students = @group.students.all.order(:name)
  end

  # GET /lesson/:id/logs/1/edit
  def edit
    @students = @group.students.all.order(:name).to_a
    @log.to_a
  end

  # POST /lesson/:id/logs
  # POST /lesson/:id/logs.json
  def create
    transaction_id = Time.now.to_i + @lesson.id
    Log.transaction do
      log_params[:flag].each do |key, value|
        log = @lesson.logs.new
        log.student_id = key.to_i
        log.flag = value
        log.date = log_params[:date]
        log.transaction_id = transaction_id
        log.save
      end
    end

    redirect_to lesson_logs_path, notice: 'Log was successfully created.'
  end

  # PATCH/PUT /lesson/:id/logs/1
  # PATCH/PUT /lesson/:id/logs/1.json
  def update
    index = 0
    Log.transaction do
      log_params[:flag].each do |key, value|
        @log[index].student_id = key.to_i
        @log[index].flag = value
        @log[index].date = log_params[:date]
        @log[index].save
        index+=1
      end
    end
    redirect_to lesson_logs_path, notice: 'Log was successfully updated.'
  end

  # DELETE /lesson/:id/logs/1
  # DELETE /lesson/:id/logs/1.json
  def destroy
    Log.transaction do
      @log.each do |log|
        log.destroy
      end
    end
    respond_to do |format|
      format.html { redirect_to lesson_logs_path, notice: 'Log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private

  def check_lesson_id(id = params[:lesson_id])
    unless Lesson.exists?(id: id)
      redirect_to groups_path, alert: 'Lesson with this id does not exist'
    end
  end

  def check_logs_date date = params[:date]
    unless Log.exists?(date: date)
      redirect_to lesson_logs_path, alert: 'Logs with this date does not exist'
    end
  end

def set_group
    @group = @lesson.group
  end

  def check_students
    if @group.students.blank?
      redirect_to lesson_logs_path, alert: 'Add students at first.'
    end
  end

# Use callbacks to share common setup or constraints between actions.
  def set_log
    @log = @lesson.logs.joins(:student).where(date: params[:date], transaction_id: params[:transaction_id]).order(:date, 'students.name')
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def log_params
    params.require(:log).permit(:date, flag: params[:log][:flag].try(:keys))
  end
end
