class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :avatar, null: false
      t.string :google_uid, null: false

      t.timestamps
    end
    add_index :users, :google_uid, unique: true
  end
end
