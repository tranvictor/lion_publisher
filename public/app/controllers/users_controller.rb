class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :click_ad]

  def show
    @user = User.find(params[:id])
    if request_from_mobile
        @images = UploadImage.order('created_at DESC')\
            .where(user_id: @user.id)\
            .paginate(:page => params[:page], :per_page => 10)
        @from_mobile = true
    else
        @images = UploadImage.order('created_at DESC')\
          .where(user_id: @user.id).paginate(:page => params[:page])
        @from_mobile = false
    end
    @total_views = @user.upload_images.map(&:impressions_count).sum(&:to_i)
    @total_likes = @user.upload_images.map(&:count_like).sum(&:to_i)
  end

  def edit
    @user = User.find(params[:id])
    redirect_to root_path unless current_user.id == @user.id
  end

  def update
    @user = User.find(params[:id])
    redirect_to root_path unless current_user.id == @user.id
    sdomain = params[:user][:shorten_domain].strip
    if sdomain.length > 0 && sdomain.end_with?('/')
      params[:user][:shorten_domain] = sdomain.slice(0..-2)
    end
    if params[:user][:password].blank?
      params[:user].delete("current_password")
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      if @user.update_attributes(params[:user])
        sign_in @user, :bypass => true
        flash[:notice] = 'Update successfully.'
        redirect_to :action => "edit"
      else
        render :action => "edit"
      end
    else
      if @user.update_with_password(params[:user])
        sign_in @user, :bypass => true
        flash[:notice] = 'Update successfully.'
        redirect_to :action => "edit"
      else
        render :action => "edit"
      end
    end
  end
end
