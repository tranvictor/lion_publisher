class DropImpressionistsTable < ActiveRecord::Migration
  def up
    drop_table :impressions
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
