class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.integer :card_number
      t.integer :expiration_year
      t.integer :expiration_month
      t.integer :securityCode
      
      t.timestamps
    end
  end
end
