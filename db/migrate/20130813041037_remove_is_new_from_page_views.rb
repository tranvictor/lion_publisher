class RemoveIsNewFromPageViews < ActiveRecord::Migration
  def up
    remove_column :page_views, :is_new
  end

  def down
    add_column :page_views, :is_new, :boolean
  end
end
