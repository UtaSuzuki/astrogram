class AddColumnItemLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :item_links, :nLink, :integer
  end
end
