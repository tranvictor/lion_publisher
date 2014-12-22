class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :upload_image_id
      t.string :content

      t.timestamps
    end

    add_index :comments, :user_id
    add_index :comments, :upload_image_id
  end
end
