class AddShortenDomainToUser < ActiveRecord::Migration
  def change
    add_column :users, :shorten_domain, :string
  end
end
