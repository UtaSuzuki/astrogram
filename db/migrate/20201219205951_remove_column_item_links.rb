class RemoveColumnItemLinks < ActiveRecord::Migration[5.2]
  def change
    remove_column :item_links, :nLink, :integer
  end
end
