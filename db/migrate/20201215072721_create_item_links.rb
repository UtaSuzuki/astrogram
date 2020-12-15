class CreateItemLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :item_links do |t|
      t.integer :condition_id
      t.string  :camera
      t.string  :lens
      t.string  :telescope
      t.string  :filter
      t.string  :mount
      t.string  :tripod

      t.timestamps
    end
  end
end
