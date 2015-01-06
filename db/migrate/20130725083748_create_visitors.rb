class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :ip
      t.integer :publisher_id

      t.timestamps
    end

    add_index :visitors, :ip, unique: true
  end
end
