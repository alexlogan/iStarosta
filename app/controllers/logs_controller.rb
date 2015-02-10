class LogsController < ApplicationController
  # before_filter :authenticate_user!, except: :index
  before_action :check_lesson_id
  load_and_authorize_resource :lesson
  load_and_authorize_resource :through => :lesson
  skip_load_and_authorize_resource :only => :index
  before_action :set_group
  before_action :check_students, only: [:new, :create]
  before_action :set_log, only: [:show, :edit, :update, :destroy]


  # GET /logs
  # GET /logs.json
  def index
    logs = Log.joins(:student).where(lesson_id: params[:lesson_id]).order('date', 'students.name')
    @grid = PivotTable::Grid.new do |g|
      g.source_data = logs
      g.column_name = :date
      g.row_name = :student
      g.value_name = :flag
    end
    @grid.build
  end

  # GET /logs/1
  # GET /logs/1.json
  def show
  end

  # GET /logs/new
  def new
    @students = @group.students.all.order(:name)
    # @log = @group.logs.build
  end

  # GET /logs/1/edit
  def edit
    @students = @group.students.all.order(:name).to_a
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

    redirect_to lesson_logs_path, notice: 'Log was successfully created.'
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
    redirect_to lesson_logs_path, notice: 'Log was successfully updated.'
  end

  # DELETE /logs/1
  # DELETE /logs/1.json
  def destroy
    @log.each do |log|
      log.destroy
    end
    respond_to do |format|
      format.html { redirect_to lesson_logs_path, notice: 'Log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def check_lesson_id(id = params[:lesson_id])
      if Lesson.exists?(id: id)
        flash.now[:lesson_name] = Lesson.find(id).name
      else
        redirect_to groups_path, alert: 'Lesson with this id does not exist'
      end
    end

    def set_group
      @group = Lesson.find(params[:lesson_id]).group
      session[:group_id] = @group.id
    end

    def check_students
      if @group.students.blank?
        redirect_to lesson_logs_path, alert: 'Add students at first.'
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
