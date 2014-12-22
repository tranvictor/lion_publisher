class CronJob
  def self.send_newsletter
    time = Time.now
    puts "-" * 80
    puts "Started at: #{time}"
    @html = nil
    @subscribers = Subscriber.all
    @subscribers.each do |sub|
      message = SubscriberMailer.news_email(sub, @html)
      puts message.inspect
      puts message.body.inspect
      @html ||= message.body.empty? ? nil : message.body.raw_source
      message.deliver
    end
    puts "Finished in: #{Time.now - time} seconds"
  end

  def self.save_article_page_view
    articles = Article.where(:published => true)
    puts "-" * 80
    puts "time: #{Time.now}"
    today = Date.current.to_time.to_i / 86400
    old_attr = "p#{(today - 7) % 8}"
    RedisConnectionPool.instance.with do |connection|
      articles.each do |article|
        values = connection.hgetall "article-#{article.id}"
        values.keep_if { |_, value| value.to_i > 0 }
        updated_attrs = values.merge(values) do |key, value|
          value.to_i + article.read_attribute(key)
        end
        if values.size > 0
          puts "article|#{article.id}"
          puts "value:#{values}"
          updated_attrs[old_attr] = 0 # erase stat of the day we dont care about
          article.assign_attributes(updated_attrs, without_protection: true)
          article.save
          values.each do |key, value|
            connection.hincrby "article-#{article.id}", key, -1 * value.to_i
          end
        end
      end
    end
  end
end
