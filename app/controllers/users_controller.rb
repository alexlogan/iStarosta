class UsersController < ApplicationController
  before_action :set_user
  before_action :check_auth
  before_action :check_uploaded_file, only: :import_logs

  rescue_from IOError, :with => :import_error

  def account
  end

  def export
    if export_params[:block].present?
      export_report(export_params[:block])
    else
      if export_params[:subject].present?
        case export_params[:subject]
          when 'logs'
            send_data @user.group.logs.to_csv, filename: "All logs.csv"
          when 'lessons'
            send_data @user.group.lessons.to_csv, filename: "All lessons.csv"
          when 'students'
            send_data @user.group.students.to_csv, filename: "All students.csv"
          else
            redirect_to user_account_path, alert: 'Ошибка при экспорте'
        end
      end
    end
  end

  def import_logs
    Log.import(@user, params[:file])
    redirect_to lessons_path, notice: 'Logs imported.'
  end

  private

  def import_error
    redirect_to user_account_path, alert: 'Ошибка импорта логов, проверьте корректность данных'
  end

  def export_report(params)
    @lessons = @user.group.lessons.where(semester: @user.group.setting.current_semester).order(:name)
    @students = @user.group.students.all.order(:name)
    flash.now[:block] = params
    render :xlsx => 'export_report',
           filename: params == 'first' ? "#{@user.group.name}_1_блок.xlsx" : "#{@user.group.name}_2_блок.xlsx"
  end

  def check_uploaded_file(file = params[:file])
    if file.present?
      redirect_to user_account_path, alert: 'Разрешается импортировать только файл .csv' unless file.content_type == 'text/csv'
    else
      redirect_to user_account_path, alert: 'Файл не выбран'
    end
  end

  def check_auth
    raise CanCan::AccessDenied unless user_signed_in?
  end

  def set_user
    @user = current_user
  end

  def export_params
    params.require(:export).permit(:block, :subject)
  end
end
