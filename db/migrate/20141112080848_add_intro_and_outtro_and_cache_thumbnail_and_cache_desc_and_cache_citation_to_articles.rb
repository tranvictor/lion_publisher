class AddIntroAndOuttroAndCacheThumbnailAndCacheDescAndCacheCitationToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :intro, :text
    add_column :articles, :outtro, :text
    add_column :articles, :cache_thumbnail, :text
    add_column :articles, :cache_citation, :text
    add_column :articles, :cache_desc, :text
  end
end
