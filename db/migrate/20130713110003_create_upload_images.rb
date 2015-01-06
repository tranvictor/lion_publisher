class CreateUploadImages < ActiveRecord::Migration
   def change
    create_table :upload_images do |t|
      t.integer :user_id
      t.string :title
      t.string :image_url
      t.text :body
      t.string :citation

      t.timestamps
    end
  end
end
