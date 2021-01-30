class CreatePhotoComments < ActiveRecord::Migration[5.2]
  def change
    create_table :photo_comments do |t|
      t.integer :user_id
      t.integer :photo_id
      t.string :message

      t.timestamps
    end
  end
end
