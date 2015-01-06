class AddPaymentToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :payment, :string
  end
end
