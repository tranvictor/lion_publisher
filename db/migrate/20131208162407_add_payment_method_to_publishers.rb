class AddPaymentMethodToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :checks_address, :string
    add_column :publishers, :checks_city, :string
    add_column :publishers, :checks_state, :string
    add_column :publishers, :checks_zipcode, :string
    add_column :publishers, :bank_bank_name, :string
    add_column :publishers, :bank_account_number, :string
    add_column :publishers, :bank_routing_number, :string
    add_column :publishers, :foreign_swift_code, :string
    add_column :publishers, :foreign_account_number, :string
    add_column :publishers, :foreign_irc_code, :string
    add_column :publishers, :foreign_iban_code, :string
    add_column :publishers, :payment_method, :integer
  end
end
