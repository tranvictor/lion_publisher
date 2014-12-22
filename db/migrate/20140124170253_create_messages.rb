class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :ip
      t.string :name
      t.string :email
      t.string :title
      t.string :body
      t.string :state
      t.integer :user_id

      t.timestamps
    end
  end
end
