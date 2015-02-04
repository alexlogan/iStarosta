class GroupsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]
  before_action :set_group, only: [:show, :edit, :update]

  # GET /groups
  # GET /groups.json
  def index
    session[:group_id] = nil
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    session[:group_id] = params[:id]
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
