class PasswordController < ApplicationController
  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update(user_params)
      flash[:notice]= "Your password has been updated."
      redirect_to('/profile')
    else
     flash[:error]= "Your passwords do not match"
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
