class AddBankAccountAndNameToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :bank_account, :string
    add_column :publishers, :name, :string
    add_column :publishers, :paypal_email, :string
    add_column :publishers, :address, :string
  end
end
