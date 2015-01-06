class RemoveImpressionsCountFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :impressions_count
    add_column :articles, :total_pageview, :integer, default: 0
  end
end
