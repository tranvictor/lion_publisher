class AddForeignAddressToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :foreign_address, :string
  end
end
