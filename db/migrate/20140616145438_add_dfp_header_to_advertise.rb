class AddDfpHeaderToAdvertise < ActiveRecord::Migration
  def change
    add_column :advertises, :dfp_header_mobile, :string
    add_column :advertises, :dfp_header_desktop, :string
  end
end
