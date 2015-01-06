class ChangeStatPageView < ActiveRecord::Migration
  def change
    change_column :page_views, :number, :float
    change_column :page_views, :number_new, :float
  end
end
