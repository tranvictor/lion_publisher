require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  test "should not save category without name" do
    category = Category.new
    category.name = ''
    assert !category.save, "Saved the category without a name"
  end

  test "should not save category with name which has already been taken" do
    category = Category.new
    category.name = categories(:one).name
    assert !category.save, "Saved the category name which has already been taken"
  end
end