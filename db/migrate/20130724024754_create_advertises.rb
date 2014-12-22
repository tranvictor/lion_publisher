class CreateAdvertises < ActiveRecord::Migration
  def change
    create_table :advertises do |t|
      t.text :top_userimage_desktop
      t.text :top_userimage_mobile
      t.text :top_article_desktop
      t.text :top_article_mobile
      t.text :bot_homepage_desktop
      t.text :bot_homepage_mobile
      t.text :bot_popular_desktop
      t.text :bot_popular_mobile
      t.text :bot_userimage_desktop
      t.text :bot_userimage_mobile
      t.text :bot_article_desktop
      t.text :bot_article_mobile
      t.text :side_article_desktop
      t.text :side_article_mobile

      t.timestamps
    end
  end
end
