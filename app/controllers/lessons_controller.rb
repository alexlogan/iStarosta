class LessonsController < ApplicationController
  before_filter :authenticate_user!, except: :index
  before_action :set_group
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]

  # GET /lessons
  # GET /lessons.json
  def index
    @lessons = @group.lessons.all
  end

  # GET /lessons/1
  # GET /lessons/1.json
  def show
  end

  # GET /lessons/new
  def new
    @lesson = @group.lessons.build
  end

  # GET /lessons/1/edit
  def edit
  end

  # POST /lessons
  # POST /lessons.json
  def create
    @lesson = @group.lessons.build(lesson_params)

    respond_to do |format|
      if @lesson.save
        format.html { redirect_to lessons_url, flash: {success: 'Lesson was successfully created.'}}
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
        format.html { redirect_to lessons_url, flash: {success: 'Lesson was successfully updated.'}}
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
      format.html { redirect_to lessons_url, flash: {success: 'Lesson was successfully destroyed.'}}
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
    def set_lesson
      if @group.lessons.exists?(id: params[:id])
        @lesson = @group.lessons.find(params[:id])
      else
        flash[:danger] = 'Lesson with this id does not exist'
        redirect_to lessons_path
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:name)
    end
end
