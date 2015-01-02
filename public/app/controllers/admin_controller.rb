class AdminController < ApplicationController
  @@master_password = "123456"
  @@admin = "duyllc"
  def login
    require "digest"
    encrypted_password=Digest::MD5.hexdigest(@@master_password)
    encrypted_user=Digest::MD5.hexdigest(@@admin)
    respond_to do |format|
      if (session[:password] == encrypted_password) && (session[:user] == encrypted_user)
        format.html { redirect_to :controller=>'articles',\
                      :action=>'new'}
      else
        format.html
      end
    end
  end

  def check
    require "digest"
    encrypted_password=Digest::MD5.hexdigest(@@master_password)
    encrypted_user=Digest::MD5.hexdigest(@@admin)
    Rails.logger.debug(params)
    respond_to do |format|
      if (session[:password] == encrypted_password) && (session[:user] == encrypted_user)
        format.html { redirect_to :controller=>'articles',\
                      :action=>'new'}
      else
        if (Digest::MD5.hexdigest(params[:password]) == encrypted_password) \
          && (Digest::MD5.hexdigest(params[:user]) == encrypted_user)
          session[:password] = encrypted_password
          session[:user] = encrypted_user
          format.html { redirect_to :controller=>'articles',\
                        :action=>'new'}
        else
          format.html {render action: "login"}
        end
      end
    end
  end

  def logout
    session[:password]=nil
    session[:user]=nil
    respond_to do |format|
      format.html { redirect_to articles_path}
    end
  end
end
