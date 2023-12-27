class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.references :publisher, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.string :name
      t.integer :price

      t.timestamps
    end
  end
end
