include Rails.application.routes.url_helpers

class Ranking
  def initialize(articles)
    @articles = articles
  end

  def trending_html
    RedisConnectionPool.instance.with do |connection|
      cached_trending = connection.get "trending"
      return cached_trending unless cached_trending.nil?
    end
    template = <<-TEMPLATE
      <li><div style="background-image: url(%s)" class="image"></div>
        <div class="overlay"></div>
        <div class="info">
          <h2 style="background-color: #0aa" class="category">%s</h2>
          <h1 class="title"><a href="%s">%d. %s</a></h1>
        </div>
      </li>
    TEMPLATE
    result = ""
    @articles.each_with_index do |article, index|
      result << template % [article.hi_thumbnail, article.category.name,
                            article_path(article),
                            index + 1, article.title]
    end
    RedisConnectionPool.instance.with do |connection|
      connection.set "trending", result, ex: 3600
      ids = @articles.collect { |a| a.id }
      connection.set "trending-article-ids", ids.join('|')
    end
    result
  end

  def to_html
    <<-HTML
      <div class="trending">
        <div class="row">
          <div class="columns">
            <ul class="slides">
              #{trending_html}
            </ul>
          </div>
        </div>
      </div>
    HTML
  end
end
