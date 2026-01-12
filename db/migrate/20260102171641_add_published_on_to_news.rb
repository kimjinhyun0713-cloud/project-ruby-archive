class AddPublishedOnToNews < ActiveRecord::Migration[8.1]
  def change
    add_column :news, :published_on, :date
  end
end
