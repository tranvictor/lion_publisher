class AddAttachmentContentToUploadImages < ActiveRecord::Migration
  def self.up
    change_table :upload_images do |t|
      t.attachment :content
    end
  end

  def self.down
    drop_attached_file :upload_images, :content
  end
end
