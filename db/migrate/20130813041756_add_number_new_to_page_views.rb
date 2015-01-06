class AddNumberNewToPageViews < ActiveRecord::Migration
  def change
    add_column :page_views, :number_new, :integer, :default => 0
  end
end
