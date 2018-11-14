class CreateTArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :t_articles, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY AUTO_INCREMENT'
      t.column :t_user_id, 'BIGINT', null: false # 会員ID
      t.integer :article_type, limit: 1, null: false # 記事タイプ
      t.string :title, limit: 255, null: false # タイトル
      t.text :body, null: false # 本文
      t.integer :sort, default: nil
      t.boolean :del_flg, default: 0, null: false # 削除フラグ(1:削除)
      t.timestamps
    end
    add_index :t_articles, [:t_user_id, :del_flg], name: 'article_index'
    add_index :t_articles, [:t_user_id, :article_type, :del_flg], name: 'article_type_index'
  end
end
