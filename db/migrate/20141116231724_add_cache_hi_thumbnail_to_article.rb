class AddCacheHiThumbnailToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :cache_hi_thumbnail, :text
  end
end
