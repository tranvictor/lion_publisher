class UsersController < ApplicationController
  load_and_authorize_resource

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    sdomain = params[:user][:shorten_domain].strip
    if sdomain.length > 0 && sdomain.end_with?('/')
      params[:user][:shorten_domain] = sdomain.slice(0..-2)
    end
    if params[:user][:password].blank?
      params[:user].delete("current_password")
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      if @user.update_attributes(user_params)
        sign_in @user, :bypass => true
        flash[:notice] = 'Update successfully.'
        redirect_to :action => "edit"
      else
        render :action => "edit"
      end
    else
      if @user.update_with_password(user_params)
        sign_in @user, :bypass => true
        flash[:notice] = 'Update successfully.'
        redirect_to :action => "edit"
      else
        render :action => "edit"
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation, 
                                :remember_me, :name, :avatar)
  end
end
