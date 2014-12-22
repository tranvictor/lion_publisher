class SubscriberMailer < ActionMailer::Base
  default from: "news@trendsread.com"

  def news_email(subscriber, html=nil)
    @subscriber = subscriber
    unless html
      date = Date.today
      @articles = Article.where(:published => true, :publish_date => date)
      return if @articles.size == 0
    end
    if html
      mail(:to => @subscriber.email,
           :body => html,
           :content_type => "text/html",
           :subject => "What's new on Trendsread.com")
    else
      mail(:to => @subscriber.email, :subject => "What's new on Trendsread.com")
    end
  end
end
