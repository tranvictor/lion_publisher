class UploadImagesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :random]

  def index
    if request_from_mobile
        @images = UploadImage.order("created_at DESC")\
            .paginate(:page => params[:page], :per_page => 10)
        @from_mobile = true
    else
        @images = UploadImage.order("created_at DESC")\
            .paginate(:page => params[:page])
        @from_mobile = false
    end

    session[:page] = "home"
    session[:image_ids] = nil
    session[:image_ids] = UploadImage.order("created_at DESC").map(&:id)
  end

  def create
    @image = current_user.upload_images.build(params[:upload_image])
    if @image.save
      html = render_to_string :partial => "edit", :layout => false, :locals => { image: @image }
      render json: { success: true, id: @image.id, html: html }
    else
      render json: { success: false, errors: @image.errors.full_messages.join(', ') }
    end
  end

  def edit
    @image = UploadImage.find(params[:id])
  end

  def update
    @image = UploadImage.find(params[:id])
    @image.update_attributes(params[:upload_image])
    redirect_to root_path
  end

  def destroy
    @image = UploadImage.find(params[:id])
    if session[:image_ids]
      session[:image_ids] = session[:image_ids] - [@image.id]
    end
    @image.destroy
    redirect_to user_path(current_user)
  end

  def like_this
    @image = UploadImage.find(params[:id])
    if params[:liked] == "false"
      @l = Like.new({user_id: current_user.id, upload_image_id: @image.id})
      begin
        @l.save
      rescue Exception
        render json: { success: false, error: @l.errors.full_messages.join(', ') }
        return
      end
    else
      @l = Like.where(user_id: current_user.id, upload_image_id: @image.id).first
      @l.destroy
    end
    render json: { success: true }
  end

  def show
    if request_from_mobile
      @from_mobile = true
    else
      @from_mobile = false
    end
    if session[:image_ids] == nil
      session[:page] = "home"
      session[:image_ids] = UploadImage.order("created_at DESC").map(&:id)
    end

    @articles = Article.order(Settings.random_query).first(3)
    if session[:page] == "random"
      @uploaded_image = UploadImage.find(session[:image_id])
    else
      @uploaded_image = UploadImage.find(params[:id])
    end

    if session[:page] == "random"
      @next = UploadImage.all.sample
      @prev = UploadImage.all.sample
    else
      id_next = find_next(session[:image_ids], @uploaded_image.id, 1)
      @next = UploadImage.find(id_next)
      id_prev = find_next(session[:image_ids], @uploaded_image.id, -1)
      @prev = UploadImage.find(id_prev)
    end

    if @from_mobile
        @articles = Article.order(Settings.random_query).first(3)
    else
        @articles = Article.order(Settings.random_query).first(6)
    end
    @uploaded_image = UploadImage.find(params[:id])
    if session[:viewed_image] == nil
      session[:viewed_image] = [params[:id]]
      if @uploaded_image.impressions_count == nil
        @uploaded_image.impressions_count = 1
      else
        @uploaded_image.impressions_count += 1
      end
      @uploaded_image.save
    else
      if !session[:viewed_image].include? params[:id]
        session[:viewed_image].push(params[:id])
        if @uploaded_image.impressions_count == nil
          @uploaded_image.impressions_count = 1
        else
          @uploaded_image.impressions_count += 1
        end
        @uploaded_image.save
      end
    end

    if @from_mobile
        @images = UploadImage.where('id<>?', @uploaded_image.id).order(Settings.random_query).first(3)
    else
        @images = UploadImage.where('id<>?', @uploaded_image.id).order(Settings.random_query).first(6)
    end
    @comments = @uploaded_image.comments.order('created_at DESC')
    if @comments.count > 5
      @comments = @comments.take(5).reverse
      @more = true
    else
      @comments = @comments.reverse
      @more = false
    end

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def random
    if UploadImage.count > 0
      session[:page] = "random"
      @random_img = UploadImage.all.sample
      session[:image_id] = nil
      session[:image_id] = @random_img.id
      redirect_to upload_image_path(@random_img)
    else
      redirect_to root_path, notice: 'There are no images.'
    end
  end

  private
  def find_next(image_ids, id, step)
    pos = image_ids.index(id)
    if pos + step > image_ids.length - 1
      image_ids[0]
    else
      image_ids[pos + step]
    end
  end
end
