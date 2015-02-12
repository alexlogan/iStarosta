class GroupsController < ApplicationController
  load_and_authorize_resource
  # before_action :set_group, only: [:show, :edit, :update]

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to groups_path, :alert => exception.message
  end

  # GET /groups
  # GET /groups.json
  def index
    @groups = @groups.order(:name)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/1/edit
  def edit
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params[:group]
    end
end
