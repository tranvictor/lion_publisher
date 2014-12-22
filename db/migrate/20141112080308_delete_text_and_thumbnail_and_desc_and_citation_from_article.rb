class DeleteTextAndThumbnailAndDescAndCitationFromArticle < ActiveRecord::Migration
  def change
    remove_column :articles, :text
    remove_column :articles, :thumbnail
    remove_column :articles, :desc
    remove_column :articles, :citation
  end
end
