class AddPublishDateToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :publish_date, :date
  end
end
