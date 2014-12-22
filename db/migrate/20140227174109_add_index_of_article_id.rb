class AddIndexOfArticleId < ActiveRecord::Migration
  def up
    add_index :pages, :article_id
  end

  def down
    remove_index :pages, :article_id
  end
end
