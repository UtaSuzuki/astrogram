class ChangeColumnItemLinks < ActiveRecord::Migration[5.2]
  def change
    change_column :item_links, :camera,    :text
    change_column :item_links, :lens,      :text
    change_column :item_links, :telescope, :text
    change_column :item_links, :filter,    :text
    change_column :item_links, :mount,     :text
    change_column :item_links, :tripod,    :text
  end
end
