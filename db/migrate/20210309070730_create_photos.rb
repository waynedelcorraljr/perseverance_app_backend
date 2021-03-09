class CreatePhotos < ActiveRecord::Migration[6.0]
  def change
    create_table :photos do |t|
      t.integer :sol
      t.string :status
      t.string :img_src
      t.string :earth_date
      t.integer :earth_date_id

      t.timestamps
    end
  end
end
