class PagesController < ApplicationController

  after_filter :expire_article_cache, :only => [:create, :update, :destroy]

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    begin
      @article = Article.find(params[:page][:article_id])
      @page = @article.pages.build(params[:page])

      print params
      print params[:page]

      respond_to do |format|
        if @page.save
          format.html { redirect_to @page,
                        notice: 'Page was successfully created.' }
          format.json { render json: @page,
                        status: :created, location: @page }
        else
          format.html { render action: "new" }
          format.json { render json: @page.errors, status: :unprocessable_entity }
        end
      end
    rescue Exception  => exc
      logger.error("Message for the log file #{exc.message}")
      respond_to do |format|
        format.html { render action: "new" }
        @page = Page.new(params[:page])
        @page.errors[:article_id] << "doesn't exist"
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @article = @page.article
    @page.destroy

    expire_fragment controller: 'articles', action: :show, id: @page.article_id

    respond_to do |format|
      format.html { redirect_to :controller => 'articles',
        :action => 'edit', :id => @article.id}
      format.json { head :no_content }
    end
  end

  private
  def expire_article_cache
    @article = @page.article
    @article.update_all
    expire_fragment controller: 'articles', action: :show, id: @article.id
    RedisConnectionPool.instance.with do |connection|
      ids = connection.get "trending-article-ids"
      if ids == nil || ids.split('|').include?(@article.id.to_s)
        connection.del "trending"
      end
    end
  end
end
