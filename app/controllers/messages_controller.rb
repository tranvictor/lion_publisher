class MessagesController < ApplicationController
  load_and_authorize_resource
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.where(:state => "Unread")
    @unread_messages_count = Message.where(:state => "Unread").count

    respond_to do |format|
      format.html { render :layout => "minimal" }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    begin
      @message = Message.find(params[:id])
    rescue
      @message = Message.first
      return redirect_to messages_path
    end
    if @message.state == "Unread"
      @message.state = "Read"
      @message.save()
    end
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new
    if current_user
      @message.name = current_user.name
      @message.email = current_user.email
    end

    respond_to do |format|
      format.html { render layout: "minimal" }
      format.json { render json: @message }
    end
  end

  # POST
  def reply
    @message = Message.find(params[:message_id]) rescue (return head :not_found)

    if @message.email == nil || @message.email.blank? || params[:body].blank?
      return head(:no_content)
    end

    MessageMailer.reply(@message.email, @message.title, params[:body])

    respond_to do |format|
      format.html
      format.json { head :ok }
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    if verify_recaptcha(:model => @errors)
      if current_user
        @message.user_id = current_user.id
      end
      @message.ip = request.remote_ip
      @message.state = "Unread"

      respond_to do |format|
        if @message.save
          format.html { redirect_to root_path, notice: 'Message was successfully sent.' }
          format.json { render json: root_path, status: :created, location: @message }
        else
          format.html { render action: "new" }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    else
      flash.now[:notice] = "There was an error with the recaptcha code below. Please re-enter the code."
      #flash.delete :recaptcha_error
      render :new, :layout => "minimal"
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end
end
