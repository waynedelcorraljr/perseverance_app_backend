class AddLikesToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_column :photos, :likes, :integer
  end
end
