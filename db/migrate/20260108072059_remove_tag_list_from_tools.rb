class RemoveTagListFromTools < ActiveRecord::Migration[8.1]
  def change
    remove_column :tools, :tag_list, :string
  end
end
