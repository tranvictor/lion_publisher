class AddIndexOfSomeFields < ActiveRecord::Migration
  def up
    add_index :articles, :impressions_count
  end

  def down
    remove_index :articles, :impressions_count
  end
end
