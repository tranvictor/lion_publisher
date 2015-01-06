class CreatePageViews < ActiveRecord::Migration
  def change
    create_table :page_views do |t|
      t.string :session_id
      t.integer :publisher_id

      t.timestamps
    end

    add_index :page_views, :session_id, unique: true
  end
end
