class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.string :ip
      t.string :session_id
      t.integer :publisher_id

      t.timestamps
    end

    add_index :clicks, [:ip, :session_id], unique: true
  end
end
