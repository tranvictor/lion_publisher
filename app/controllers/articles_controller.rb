require "open-uri"
require "redis"
require 'actionpack/action_caching'

class ArticlesController < ApplicationController
  load_and_authorize_resource

  # GET /articles
  # GET /articles.json
  #before_filter :tracking, :only => [:index, :show]
  before_filter :before_cache, :only => [:show]
  after_filter :clear_article_cache, :only => [:update, :destroy]
  caches_action :show, :cache_path => Proc.new { |c| c.params },
                :expires_in => 1.day

  def index
    if params[:category] == nil
      if params[:mostpopular] == 'true'
        @articles = Article.select([:id, :title, :category_id,
                                    :cache_thumbnail, :cache_desc, :cache_citation])
          .includes(:category)
          .where(:published => true)
          .order('impressions_count DESC')
          .paginate(:page => params[:page])
        @mostpopular = true
      else
        @articles = Article.select([:id, :title, :category_id,
                                    :cache_thumbnail, :cache_desc, :cache_citation])
          .includes(:category)
          .where(:published => true)
          .order('created_at DESC')
          .paginate(:page => params[:page])
        @mostpopular = false
      end
    else
      @cat = Category.find(params[:category])
      @cat_id = @cat.parent_id || @cat.id
      if @cat.parent_id
        cat_ids = [@cat.id]
      else
        cat_ids = Category.category_tree[@cat.id].collect { |c| c.id }
      end
      puts cat_ids
      @articles = Article.select([:id, :title, :category_id,
                                  :cache_thumbnail, :cache_desc, :cache_citation])
        .includes(:category)
        .where(:category_id => cat_ids)
        .where(:published => true)
        .order('created_at DESC')
        .paginate(:page => params[:page])
    end
    if session[:mobile_detected] == true
      @from_mobile = true
    else
      @from_mobile = false
    end
    @trending = Ranking.new(Article.trending).to_html
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
    end
  end

  def random
    @article = Article.select(:id)
                      .where('category_id <> ?', Settings.isolated_cat_id)
                      .where(:published => true)
                      .order(Settings.random_query).first
    unless @article.nil?
      redirect_to article_path @article
      return
    end
    redirect_to root_path
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id]) rescue (return redirect_to(root_path))
    @previous_id = Article.where("category_id = ? AND id > ?", 
                                  @article.category_id, @article.id)
                          .where(:published => true).minimum(:id)
    @next_id = Article.where("category_id = ? AND id < ?",
                                  @article.category_id, @article.id)
                      .where(:published => true).maximum(:id)

    if @article.category_id != nil
      @recommend_articles = Article.where(:category_id => @article.category_id)
                                   .where(:published => true)
                                   .where('id <> ?', @article.id)
                                   .order(Settings.random_query)
                                   .first(12)
    else
      @recommend_articles = Article.where(:published => true)
                                    .where('id <> ?', @article.id)
                                    .order(Settings.random_query)
                                    .first(12)
    end
    @pages = @article.sorted_pages
    params[:category] = @article.category_id
    @cat_id = @article.category.parent_id || @article.category.id
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    respond_to do |format|
      @categories = Category.all
      @article = Article.new
      format.html { render layout: 'minimal' }
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    respond_to do |format|
      begin
        @article = Article.find(params[:id])
      rescue
        return redirect_to root_path
      end

      @categories = Category.all
      @created_pages = @article.pages.order('page_no')
      format.html
    end
  end

  # POST /articles
  # POST /articles.json
  def create
    respond_to do |format|
        @article = Article.new(article_params)
        @article.user_id = current_user.id
        @article.published = false
        # @categories = Category.all
        if @article.save
          format.html { redirect_to :controller=>'articles',
                        :action=>'edit',
                        :id=>@article.id }
          format.json { render json: @article, status: :created, location: @article }
        else
          format.html { render action: "new", layout: "minimal" }
          format.js { render json: @article.errors, status: :unprocessable_entity }
        end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id]) rescue (return redirect_to root_path)

    @created_pages = @article.pages.order('page_no')
    @page = nil
    @created_pages.each do |created_page|
      paras = params['page_' + created_page.id.to_s]
      if paras != nil
        created_page.update_attributes(sanitize_page_params(paras))
      end
    end

    if params[:file] != nil
      p "abc"
      @pages = []
      max_page_no = @article.pages.maximum('page_no')
      @page = @article.pages.build(
          :image=>params[:file],
          :page_no=> max_page_no.nil? ? 1 : max_page_no + 1
      )
      @page.broken = false
      @created = @page.save
      @pages.push @page
    else
      @urls = params["image-urls"]
      @pages = []
      if @urls != '' and @urls != nil
        @urls = @urls.split(/\n/)
        @urls.each do |url|
          begin
            max_page_no = @article.pages.maximum('page_no')
            @page = @article.pages.build(
                :image=>open(url),
                :citation=>url,
                :broken=>false,
                :page_no=> max_page_no.nil? ? 1 : max_page_no + 1
            )
            @created = @page.save
            @pages.push @page if @created
          rescue
          end
        end
      end
    end
    if params[:article] == nil
      return render :json => gen_update_json(@pages)
    end
    unless params[:article].key? :published
      params[:article][:published] = false
    end
    unless params[:article].key? :is_list
      params[:article][:is_list] = false
    end
    if !@article.published && params[:article][:published]
      params[:article][:publish_date] = Date.today
    end

    @article.update_attributes(article_params)
    return render :json => gen_update_json(@pages)
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end

  def clearcache
    cache_store = Rails.application.config.cache_store[0]
    cache_location = Rails.application.config.cache_store[1]
    if current_user != nil && current_user.super_admin?
      if cache_store == :redis_store
        storage = Redis::Store.new(:url => cache_location)
        storage.flushdb
      else
        FileUtils.rm_rf(Dir['tmp/cache/[^.]*'])
      end
    end
    redirect_to root_path
  end

  private
  def before_cache
    # increase pageview of an article
    # To be able to stat last 7 days pageview, we store 8 days of pageview to
    # 8 special attrs those are: p0, p1, p2, ..., p7
    # If today is p0 then tomorrow will be p1 and yester day is p7
    # Today will be calculated as mod 8
    # The day that we will not care about anymore is (today - 7) mod 8
    today = (Date.current.to_time.to_i / 86400) % 8
    today_attr = "p#{today}"
    key = "article-#{params[:id]}"
    RedisConnectionPool.instance.with do |connection|
      connection.hincrby key, "total_pageview", 1
      connection.hincrby key, today_attr, 1
    end
  end

  def clear_article_cache
    @article.update_all
    expire_fragment controller: 'articles', action: :show, id: params[:id]
    RedisConnectionPool.instance.with do |connection|
      ids = connection.get "trending-article-ids"
      if ids == nil || ids.split('|').include?(@article.id.to_s)
        connection.del "trending"
      end
    end
  end

  def gen_update_json(pages)
    results = []
    pages.each do |page|
      results << {
        thumbnail_html: render_to_string(:partial => 'page_thumb.html.erb',
                                         :layout => false,
                                         :locals => {:page => page}),
        form_html: render_to_string(:partial => 'page_form.html.erb',
                                    :layout => false,
                                    :locals => {:page => page})
      }
    end
    results
  end

  def get_host(url)
    url = "http://#{url}" if URI.parse(url).scheme.nil?
    URI.parse(url).host.downcase
  end

  def article_params
    params.require(:article).permit(:title, :page_ids, :category_id, :published, :publish_date,
      :intro, :outtro, :cache_thumbnail, :cache_desc, :cache_citation, :is_list)
  end

  def sanitize_page_params(paras)
    paras.permit(:article_id, :body, :citation, :image, :page_no, :title, :broken)
  end
end
