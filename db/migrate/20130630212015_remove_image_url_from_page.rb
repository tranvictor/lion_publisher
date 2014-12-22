class RemoveImageUrlFromPage < ActiveRecord::Migration
  def up
    remove_column :pages, :image_url
  end

  def down
    add_column :pages, :image_url, :string
  end
end
