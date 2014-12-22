class AddRealCurrencyAndGoogleWalletToPublisher < ActiveRecord::Migration
  def change
    add_column :publishers, :real_currency, :string, :default => 'Local Currency'
    add_column :publishers, :google_wallet_email, :string
  end
end
