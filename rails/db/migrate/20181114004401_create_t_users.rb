class CreateTUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :t_users, id: false do |t|
      t.column :id, 'BIGINT PRIMARY KEY'
      t.string :encrypted_email,    limit: 255, null: false, default: '' # メールアドレス(暗号化)
      t.string :encrypted_password, limit: 255, null: false, default: '' # パスワード(暗号化)
      t.string :nickname, limit: 100, null: false # 名前
      t.string :icon_file_path, limit: 255
      t.boolean :del_flg, default: 0, null: false # 削除フラグ(1:削除)
      t.timestamps
    end
    add_index :t_users, [:id, :del_flg], name: 'user_index'
  end
end
