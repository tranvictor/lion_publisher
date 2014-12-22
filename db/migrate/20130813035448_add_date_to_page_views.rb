class AddDateToPageViews < ActiveRecord::Migration
  def change
    add_column :page_views, :date, :date
  end
end
