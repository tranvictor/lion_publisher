class AddImpressionsCountToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :impressions_count, :integer, :default => 0    
  end
end
