class FilterController < ApplicationController
  before_filter :check_admin, :only => [:brokenscanner, :broken]
  before_filter :check_writer, :only => [:index, :all]

  def check_admin
    unless user_signed_in? && current_user.admin?
      redirect_to "/", :notice => "Please login as admin to access this area!"
    end

    File.open("tmp/StartScanner.txt", "a+") do |afile|
      @line = afile.gets
    end
    if (@line == nil)
      @line = "false"
    end
    @start_scanner = (@line.strip == "true")
  end

  def check_writer
    unless user_signed_in? && (current_user.writer? or current_user.admin?)
      redirect_to "/", :notice => "Only writer or admin can access this area!!!"
    end
    @isAdmin = true
    unless user_signed_in? && current_user.admin?
      @isAdmin = false
    end
    @user = current_user
  end

  def index
  end

  def brokenscanner
    if (!@start_scanner)
      Thread.new do
        File.open("tmp/StartScanner.txt", "w") do |afile|
          afile.puts "true"
        end

        require 'net/http'
        require 'uri'
        def isLive?(url)
          uri = URI.parse(url)
          response = nil
          begin
            Net::HTTP.start(uri.host, uri.port) { |http|
              response = http.head(uri.path.size > 0 ? uri.path : "/")
            }
          rescue
            return false
          end
          return response.code == "200"
        end

        pages = Page.find(:all)
        pages.each do |page|
          if (isLive?(page.image.url(:medium)) == false)
            page.broken = true
            page.save
            #article = Article.find(page.article_id)
            #article.published = false
            #article.save
          else
            page.broken = false
            page.save
          end
        end

        File.open("tmp/StartScanner.txt", "w") do |afile|
          afile.puts "false"
        end
      end
    end
  end

  def broken
    @filter_results = []
    articles = Article.find(:all)
    articles.each do |article|
      pages = article.pages
      pages.each do |page|
        if (page.broken)
          @filter_results.append(article)
          break
        end
      end
    end
  end

  def all
    if (@isAdmin)
      @published = Article.select([:id, :title, :published, :cache_thumbnail,
                                   :cache_desc, :cache_citation])
                          .where(published: true)
      @not_published = Article.select([:id, :title, :published, :cache_thumbnail,
                                       :cache_desc, :cache_citation])
                              .where(published: false)
    else
      @published = Article.select([:id, :title, :published, :cache_thumbnail,
                                   :cache_desc, :cache_citation])
                          .where({user_id: @user.id, published: true})
      @not_published = Article.select([:id, :title, :published, :cache_thumbnail,
                                       :cache_desc, :cache_citation])
                              .where({user_id: @user.id, published: false})
    end

    respond_to do |format|
      format.html
      format.js do
        @articles = @published + @not_published
        # puts @articles.collect { |item| "#{item.published}|#{item.title}" }
        render json: @articles.to_json(:methods => [:thumbnail, :desc, :published])
      end
    end
  end
end
