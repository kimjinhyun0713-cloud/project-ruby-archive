class CreateTools < ActiveRecord::Migration[8.1]
  def change
    create_table :tools do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
