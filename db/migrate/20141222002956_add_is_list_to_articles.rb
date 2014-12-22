class AddIsListToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :is_list, :boolean, default: true
  end
end
