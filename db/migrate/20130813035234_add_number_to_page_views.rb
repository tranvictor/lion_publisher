class AddNumberToPageViews < ActiveRecord::Migration
  def change
    add_column :page_views, :number, :integer, :default => 0
  end
end
