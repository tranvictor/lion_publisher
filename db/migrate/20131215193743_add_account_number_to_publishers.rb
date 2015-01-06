class AddAccountNumberToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :foreign_bank_name, :string
    add_column :publishers, :foreign_branch_sort_code, :string
  end
end
