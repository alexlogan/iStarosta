class LessonsController < ApplicationController
  before_action :set_group
  load_and_authorize_resource :through => :group

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to group_lessons_path(@group), :alert => %Q(Couldn't find Lesson with this 'id')
  end

  # GET /lessons
  # GET /lessons.json
  def index
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

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_lesson
      if Lesson.exists?(id: params[:id])
        @lesson = Lesson.find(params[:id])
      else
        redirect_to groups_path, alert: 'Lesson with this id does not exist'
      end
    end

    def set_group
      if session[:group_id].blank?
        @group = Lesson.find(params[:id]).group
        session[:group_id] = @group.id
      else
        @group = Group.find(session[:group_id])
      end
    end

    def set_group_for_index
      if params[:group_id].present?
        @group = Group.find(params[:group_id])
        session[:group_id] = @group.id
      elsif user_signed_in?
        @group = current_user.group
      else
        redirect_to new_user_session_path, alert: 'You are not authorized'
      end
    end

  # Never trust parameters from the scary internet, only allow the white list through.
    def lesson_params
      params.require(:lesson).permit(:name)
    end
end
