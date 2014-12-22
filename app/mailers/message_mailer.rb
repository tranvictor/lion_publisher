class MessageMailer < ActionMailer::Base
  default from: "news@trendsread.com"

  def reply(to, subject, body)
    @message = message
    mail(:to => to,
         :reply_to => to,
         :subject => subject,
         :body => body)
  end
end
