class AddDefaultToMessage < ActiveRecord::Migration
  def change
    change_column :messages, :state, :string, :default => "Unread"
  end
end
