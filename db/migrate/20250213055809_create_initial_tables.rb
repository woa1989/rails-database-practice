class CreateInitialTables < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :active, default: true
      t.integer :posts_count, default: 0
      t.timestamps
    end
    add_index :users, :email, unique: true

    create_table :posts do |t|
      t.string :title, null: false
      t.text :content
      t.string :status, default: 'draft'
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index :posts, [ :status, :created_at ]

    create_table :comments do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true

    create_table :posts_tags, id: false do |t|
      t.references :post, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end
    add_index :posts_tags, [ :post_id, :tag_id ], unique: true
  end
end
