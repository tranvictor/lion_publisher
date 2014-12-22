class AddShareFbAndShareTwAndPlusToUploadImages < ActiveRecord::Migration
  def change
    add_column :upload_images, :share_fb, :integer, :default => 0
    add_column :upload_images, :share_tw, :integer, :default => 0
    add_column :upload_images, :plus, :integer, :default => 0
  end
end
