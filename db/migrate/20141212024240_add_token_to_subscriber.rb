class AddTokenToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :token, :string
  end
end
