class AddDescAndCitationToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :desc, :string
    add_column :articles, :citation, :string
  end
end
