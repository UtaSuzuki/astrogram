class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.integer :condition_id
      t.integer :categorization_id
      t.integer :size_id
      t.string  :title
      t.string  :image
      t.date    :date
      t.time    :time
      t.string  :location
      t.text    :description
      t.integer :price

      t.timestamps
    end
  end
end
