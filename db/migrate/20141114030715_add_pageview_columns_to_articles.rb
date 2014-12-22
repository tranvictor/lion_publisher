class AddPageviewColumnsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :p0, :integer, default: 0
    add_column :articles, :p1, :integer, default: 0
    add_column :articles, :p2, :integer, default: 0
    add_column :articles, :p3, :integer, default: 0
    add_column :articles, :p4, :integer, default: 0
    add_column :articles, :p5, :integer, default: 0
    add_column :articles, :p6, :integer, default: 0
    add_column :articles, :p7, :integer, default: 0
  end
end
