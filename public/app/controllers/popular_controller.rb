class PopularController < ApplicationController
  def index
    if request_from_mobile
      @images = UploadImage.order('impressions_count DESC')
                           .paginate(:per_page => 10, :page => params[:page])
      @from_mobile = true
    else
      @images = UploadImage.order('impressions_count DESC').paginate(:page => params[:page])
      @from_mobile = false
    end

    session[:page] = "popular"
    session[:image_ids] = nil
    session[:image_ids] = UploadImage.order('impressions_count DESC').map(&:id)

    respond_to do |format|
        format.html
        format.js
    end
  end

  def article_index
    redirect_to articles_path(:mostpopular => true)
  end
end
