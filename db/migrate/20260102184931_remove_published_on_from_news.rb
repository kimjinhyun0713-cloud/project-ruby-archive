class RemovePublishedOnFromNews < ActiveRecord::Migration[8.1]
  def change
    remove_column :news, :published_on, :date
  end
end
