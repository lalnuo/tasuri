class AddDigestForHousehold < ActiveRecord::Migration
  def change
    add_column :households, :password_digest, :string 
  end
end
