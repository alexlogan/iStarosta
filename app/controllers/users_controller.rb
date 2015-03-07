class UsersController < ApplicationController
  before_action :set_user
  before_action :check_auth

  def account
  end

  def export
    respond_to do |format|
      format.html { export_report(report_params) }
      format.csv { send_data @user.group.logs.to_csv, filename: "All logs.csv"}
    end
  end

  def import
    Log.import(params[:file])
    redirect_to lessons_path, notice: 'Logs imported.'
  end

  private

  def export_report(params)
    @lessons = @user.group.lessons.where(semester: @user.group.setting.current_semester).order(:name)
    @students = @user.group.students.all.order(:name)
    flash.now[:block] = params[:block]
    render :xlsx => 'export_report',
           filename: params[:block] == 'first' ? "#{@user.group.name}_1_блок.xlsx" : "#{@user.group.name}_2_блок.xlsx"
  end

  def check_auth
    raise CanCan::AccessDenied unless user_signed_in?
  end

  def set_user
    @user = current_user
  end

  def report_params
    params.permit(:block)
  end
end
