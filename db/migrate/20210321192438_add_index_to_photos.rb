class AddIndexToPhotos < ActiveRecord::Migration[6.0]
  def change
    add_index :photos, :earthdate_id
  end
end
