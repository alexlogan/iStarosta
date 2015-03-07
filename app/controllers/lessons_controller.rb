class LessonsController < ApplicationController
  before_action :check_group_id, if: Proc.new { params[:group_id] }
  before_action :check_lesson_id, if: Proc.new { params[:id] }
  before_action :set_group
  load_and_authorize_resource :through => :group

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = @lessons.order(:name)
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    respond_to do |format|
      if @lesson.save
        format.html { redirect_to lessons_url, notice: 'Lesson was successfully created.'}
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1
  # PATCH/PUT /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to lessons_url, notice: 'Lesson was successfully updated.'}
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1
  # DELETE /lessons/1.json
  def destroy
    @lesson.destroy
    respond_to do |format|
      format.html { redirect_to lessons_url, notice: 'Lesson was successfully destroyed.'}
      format.json { head :no_content }
    end
  end

  def import
    Lesson.import(params[:file])
    redirect_to lessons_path, notice: 'Lessons imported.'
  end

  private

  def check_group_id
    redirect_to groups_path, alert: %Q(Couldn't find Group with this 'id') unless Group.exists?(params[:group_id])
  end

  def check_lesson_id
    redirect_to groups_path, alert: %Q(Couldn't find Lesson with this 'id') unless Lesson.exists?(params[:id])
  end

  def set_group
    if action_name == 'index'
      @group = (Group.find(params[:group_id]) if params[:group_id]) || current_user.try(:group) || raise(CanCan::AccessDenied)
    else
      @group = (Lesson.find(params[:id]).group if params[:id]) || current_user.try(:group)
    end
  end

# Never trust parameters from the scary internet, only allow the white list through.
  def lesson_params
    params.require(:lesson).permit(:name, :kind, :semester)
  end
end
