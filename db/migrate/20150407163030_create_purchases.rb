class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :name
      t.integer :user_id
      t.float :price
      t.integer :household_id

      t.timestamps null: false
    end
  end
end
