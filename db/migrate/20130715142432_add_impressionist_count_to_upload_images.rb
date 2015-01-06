class AddImpressionistCountToUploadImages < ActiveRecord::Migration
  def change
    add_column :upload_images, :impressions_count, :integer
  end
end
