class AddDetailsToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :published, :boolean, :default => false
    add_column :pages, :broken, :boolean, :default => false
  end
end
