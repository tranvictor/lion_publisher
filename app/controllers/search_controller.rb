class SearchController < ApplicationController
  before_filter :check_user

  def index
    if (params.include? "keyword")
      if (params.include? "page")
        search_text(params[:keyword], params[:page])
      else
        search_text(params[:keyword], 1)
      end
      render :index, :layout => false
    else
      redirect_to root_path
    end
  end

  private
  def search_text(key_word, page)
    @key_words = key_word.split()
    articles = search_article_title(key_word, page)
    pages = search_page_body(key_word, page)

    if !@is_admin
      if !@is_writer
        @articles = articles.select { |a| a.published }
        @pages = pages.select { |a| a.article.published }
      else
        @articles = articles.select {
            |a| a.published or a.user_id == current_user.id }
        @pages = pages.select {
            |a| a.article.published or a.article.user_id == current_user.id}
      end
    else
      @articles = articles
      @pages = pages
    end
  end

  def search_article_title(key_word, page)
    Article.search(:select => [:id, :title, :published, :user_id]) do
        keywords key_word, :minimum_match => (key_word.split.count/2.0).ceil
        paginate :page => page
    end.results
  end

  def search_page_body(key_word, page)
    Page.search do
      keywords key_word, :minimum_match => 1
      paginate :page => page
    end.results
  end

  def check_user
    @is_admin = user_signed_in? && current_user.admin?
    @is_writer = user_signed_in? && current_user.writer?
  end

end
