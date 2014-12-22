class AddIsWriterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_writer, :boolean, :default => false
  end
end
