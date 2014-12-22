class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:view_all]

  def create
    @comment = current_user.comments.build(params[:comment])
    if @comment.save
      html = render_to_string :partial => "comment", :layout => false, :locals => { comment: @comment }
      render json: { success: true, html: html }
    else
      render json: { success: false }
    end
  end

  def view_all
    @image = UploadImage.find(params[:id])
    @comments = @image.comments.order("created_at ASC")

    html = render_to_string :partial => "all", :layout => false, :locals => { comments: @comments }

    render json: { html: html }
  end

  def destroy
    @comment = Comment.find(params[:id])
    @image = @comment.upload_image
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to upload_image_path @image }
      format.json { head :no_content }
    end
  end

end
