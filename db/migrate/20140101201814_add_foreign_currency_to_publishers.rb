class AddForeignCurrencyToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :foreign_currency, :string
  end
end
