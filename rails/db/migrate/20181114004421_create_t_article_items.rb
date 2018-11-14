class CreateTArticleItems < ActiveRecord::Migration[5.2]
  def change
    create_table :t_article_items, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY AUTO_INCREMENT'
      t.column :t_article_id, 'BIGINT', null: false # 記事ID
      t.string :title, limit: 255, null: false # タイトル
      t.text :body, null: false # 本文
      t.string :file_path, limit: 255
      t.integer :sort, default: nil
      t.boolean :del_flg, default: 0, null: false # 削除フラグ(1:削除)
      t.timestamps
    end
    add_index :t_article_items, [:t_article_id, :del_flg], name: 'article_item_index'
  end
end
