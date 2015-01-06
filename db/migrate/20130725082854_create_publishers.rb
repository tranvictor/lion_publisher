class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers do |t|
      t.string :code

      t.timestamps
    end
  end
end
