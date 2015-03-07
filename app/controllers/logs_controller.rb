class LogsController < ApplicationController
  before_action :check_lesson_id
  load_and_authorize_resource :lesson
  before_action :check_logs_date, if: Proc.new { params[:date] }
  load_and_authorize_resource :through => :lesson
  skip_load_and_authorize_resource :only => :index
  before_action :set_group
  before_action :check_students, only: [:new, :create]
  before_action :set_log, only: [:show, :edit, :update, :destroy]
  before_action :check_uploaded_file, only: :import


  # GET /lesson/:id/logs
  # GET /lesson/:id/logs.json
  def index
    logs = @lesson.logs.joins(:student).order(:date, 'students.name')
    @grid = PivotTable::Grid.new(:sort => false) do |g|
      g.source_data = logs
      g.column_name = :date
      g.row_name = :student
      g.value_name = :flag
    end
    @grid.build
    respond_to do |format|
      format.html
      format.csv { send_data logs.to_csv, filename: "#{@lesson.name.humanize} Ведомость.csv"}
    end
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
    log_params[:flag].each do |key, value|
      log = @lesson.logs.new
      log.student_id = key.to_i
      log.flag = value
      log.date = log_params[:date]
      log.save
    end

    redirect_to lesson_logs_path, notice: 'Log was successfully created.'
  end

  # PATCH/PUT /lesson/:id/logs/1
  # PATCH/PUT /lesson/:id/logs/1.json
  def update
    index = 0
    log_params[:flag].each do |key, value|
      @log[index].student_id = key.to_i
      @log[index].flag = value
      @log[index].date = log_params[:date]
      @log[index].save
      index+=1
    end
    redirect_to lesson_logs_path, notice: 'Log was successfully updated.'
  end

  # DELETE /lesson/:id/logs/1
  # DELETE /lesson/:id/logs/1.json
  def destroy
    @log.each do |log|
      log.destroy
    end
    respond_to do |format|
      format.html { redirect_to lesson_logs_path, notice: 'Log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
      Log.import(params[:file])
      redirect_to lesson_logs_path, notice: 'Logs imported.'
  end

  private

  def check_uploaded_file(file = params[:file])
    if file.present?
      redirect_to lessons_path, alert: 'Разрешается импортировать только файл .csv' unless file.content_type == 'text/csv'
    else
      redirect_to lessons_path, alert: 'Файл не выбран'
    end
  end

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
    @log = @lesson.logs.joins(:student).where(date: params[:date]).order(:date, 'students.name')
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def log_params
    params.require(:log).permit(:date, flag: params[:log][:flag].try(:keys))
  end
end
