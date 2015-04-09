class AddSlugsToHoushold < ActiveRecord::Migration
  def change
    add_column :households, :slug, :string
    add_index :households, :slug, unique: true
  end
end
