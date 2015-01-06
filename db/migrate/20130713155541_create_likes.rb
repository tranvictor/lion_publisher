class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :upload_image_id

      t.timestamps
    end

    add_index :likes, :user_id
    add_index :likes, :upload_image_id
    add_index :likes, [:user_id, :upload_image_id], unique: true
  end
end
