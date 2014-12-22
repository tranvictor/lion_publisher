class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.integer :article_id
      t.integer :page_no
      t.string :title
      t.string :image_url
      t.text :body
      t.string :citation

      t.timestamps
    end
  end
end
