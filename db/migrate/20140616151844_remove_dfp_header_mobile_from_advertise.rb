class RemoveDfpHeaderMobileFromAdvertise < ActiveRecord::Migration
  def up
    remove_column :advertises, :dfp_header_mobile
    remove_column :advertises, :dfp_header_desktop
    add_column :advertises, :dfp_header_desktop, :text
    add_column :advertises, :dfp_header_mobile, :text
  end

  def down
    add_column :advertises, :dfp_header_desktop, :string
    add_column :advertises, :dfp_header_mobile, :string
  end
end
