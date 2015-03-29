class SettingsController < ApplicationController
  before_action :set_group
  before_action :set_setting


  def edit
  end

  def update
      if @setting.update(setting_params)
         redirect_to user_account_path, notice: 'Settings updated.'
      else
        render :edit
      end
  end


  private
  def set_group
    @group = current_user.try(:group) || raise(CanCan::AccessDenied)
  end

  def set_setting
    @setting = @group.setting
  end

  def setting_params
    params.require(:setting).permit(:current_semester, :current_block, :threshold_date, :vk_group)
  end

end
