class SettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def update
    @user = current_user

    # Handle password change separately
    if params[:user][:password].present?
      if @user.update_with_password(user_params_with_password)
        bypass_sign_in(@user)
        redirect_to settings_path, notice: "Settings updated successfully."
      else
        render :show, status: :unprocessable_entity
      end
    else
      if @user.update(user_params)
        redirect_to settings_path, notice: "Settings updated successfully."
      else
        render :show, status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def user_params_with_password
    params.require(:user).permit(:name, :email, :current_password, :password, :password_confirmation)
  end
end
