class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.integer :user_id
      t.string  :title
      t.string  :image
      t.date    :date
      t.time    :start_time
      t.time    :end_time
      t.string  :location
      t.date    :deadline
      t.integer :accept_number
      t.text    :description
      t.boolean :recruit_status

      t.timestamps
    end
  end
end
