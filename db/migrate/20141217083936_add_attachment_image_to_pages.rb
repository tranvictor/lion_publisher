class AddAttachmentImageToPages < ActiveRecord::Migration
  def self.up
    change_table :pages do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :pages, :image
  end
end
