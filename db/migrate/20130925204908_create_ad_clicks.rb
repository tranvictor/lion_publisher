class CreateAdClicks < ActiveRecord::Migration
  def change
    create_table :ad_clicks do |t|
      t.date :date
      t.float :number
      t.integer :publisher_id

      t.timestamps
    end
  end
end
