require 'test_helper'

class PageTest < ActiveSupport::TestCase
  test "should not save page without article_id" do
    page = Page.new
    page.page_no = 10
    assert !page.save, "Saved the page without article_id"
  end

  test "should not save page without page_no" do
    page = Page.new
    page.article_id = 1
    assert !page.save, "Saved the page without page_no"
  end

  test "should not save page with invalid page_no (not integer)" do
    page = Page.new
    page.article_id = 1
    page.page_no = 'a'
    assert !page.save, "Saved the page without invalid page_no (not integer)"
  end

  test "should not save page with invalid page_no (<=0)" do
    page = Page.new
    page.article_id = 1
    page.page_no = -2
    assert !page.save, "Saved the page without invalid page_no (<=0)"
  end
end
