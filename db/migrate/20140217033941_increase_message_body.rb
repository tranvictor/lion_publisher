class IncreaseMessageBody < ActiveRecord::Migration
def change
    change_column :messages, :body, :string, :limit => 4000
end
  def up
  end

  def down
  end
end
