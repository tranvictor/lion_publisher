
class SubscribersController < ApplicationController

  # POST /subscribers
  # POST /subscribers.json
  def create
    @subscriber = Subscriber.new(subscriber_params)

    if @subscriber.save
      res = <<-HTML
        Successfully subscribed.
      HTML
    else
      res = <<-HTML
        #{@subscriber.errors[:email][0]}
      HTML
    end

    render text: res.html_safe
  end

  def unsubscribe
    @subscriber = Subscriber.find(params[:id]) rescue nil
    if @subscriber && @subscriber.token == params[:token]
      @subscriber.destroy
      respond_to do |format|
        format.html { redirect_to(
          root_path, notice: "You just unsubscribed successfully."
        ) }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to(
          root_path, notice: "Your token is not correct."
        ) }
        format.json { head :not_found }
      end
    end
  end

  private
  def subscriber_params
    params.require(:subscriber).permit(:email, :token)
  end
end
