class CreateConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :conditions do |t|
      t.integer :user_id
      t.string  :title
      t.string  :camera
      t.string  :lens
      t.string  :telescope
      t.string  :filter
      t.string  :mount
      t.string  :tripod
      t.text    :description

      t.timestamps
    end
  end
end
