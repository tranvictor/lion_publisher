require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  test "should not save article without title" do
    article = Article.new
    assert !article.save, "Saved the article without a title"
  end

  test "should not save article with title which has already been taken" do
    article = Article.new
    article.title = articles(:one).title
    assert !article.save, "Saved the article title which has already been taken"
  end

  test "small_thumbnail should not nil" do
    article = Article.new
    assert_not_nil article.small_thumbnail
  end

  test 'small_thumbnail should return correct url' do
    article = articles(:one)
    assert_equal(article.small_thumbnail, article.pages.order('page_no').first.image.url(:thumb))
  end

  test 'small_thumbnail should return correct url (nil => default)' do
    article = articles(:two)
    assert_equal(article.small_thumbnail, "Default image")
  end

  test "mini_thumbnail should not nil" do
    article = Article.new
    assert_not_nil article.mini_thumbnail
  end

  test "thumbnail should not nil" do
    article = Article.new
    assert_not_nil article.thumbnail
  end

  test 'thumbnail should return correct url' do
    article = articles(:one)
    assert_equal(article.thumbnail, article.pages.order('page_no').first.image.url(:medium))
  end

  test 'thumbnail should return correct url (nil => default)' do
    article = articles(:two)
    assert_equal(article.small_thumbnail, "Default image")
  end

  test "citation should not nil" do
    article = Article.new
    assert_not_nil article.citation
  end

  test "desc should not nil" do
    article = Article.new
    assert_not_nil article.desc
  end

  test "length of desc" do
    article = articles(:one)
    assert article.desc.length <= 140
  end

  test "make sure published is false (new article)" do
    article = Article.new
    assert_equal(article.published, false)
  end

  test "should destroy pages when delete article" do
    articles(:one).destroy
    assert_equal(Page.all.select { |a| a.article_id == 1 }, [])
  end
end
