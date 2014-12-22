class AddIndexOfUserIdOnPublishers < ActiveRecord::Migration
  def up
    add_index :publishers, :user_id
    add_index :articles, :user_id
    add_index :messages, :user_id
  end

  def down
    remove_index :publishers, :user_id
    remove_index :articles, :user_id
    remove_index :messages, :user_id
  end
end
