class AddTextToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :text, :text
  end
end
