class AddIndexOfPageNo < ActiveRecord::Migration
  def up
    add_index :pages, :page_no
  end

  def down
    remove_index :pages, :page_no
  end
end
