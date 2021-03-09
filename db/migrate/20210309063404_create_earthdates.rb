class CreateEarthdates < ActiveRecord::Migration[6.0]
  def change
    create_table :earthdates do |t|
      t.string :date
      t.integer :total_photos

      t.timestamps
    end
  end
end
