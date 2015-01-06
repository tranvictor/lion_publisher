class AddIsNewToPageViews < ActiveRecord::Migration
  def change
    add_column :page_views, :is_new, :boolean
  end
end
