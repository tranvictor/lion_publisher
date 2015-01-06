class AddIndexOfCategoryIdInArticles < ActiveRecord::Migration
  def up
    add_index :articles, :category_id
  end

  def down
    remove_index :articles, :category_id
  end
end
