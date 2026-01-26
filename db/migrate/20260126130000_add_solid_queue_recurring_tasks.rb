class AddSolidQueueRecurringTasks < ActiveRecord::Migration[7.1]
  def change
    drop_table :solid_queue_recurring_tasks, if_exists: true

    create_table :solid_queue_recurring_tasks do |t|
      t.string :key, null: false
      t.string :schedule, null: false
      t.string :command, limit: 2048
      t.string :class_name
      t.text :arguments
      t.string :queue_name
      t.integer :priority, default: 0
      t.boolean :static, default: true, null: false
      t.text :description

      t.timestamps
    end

    add_index :solid_queue_recurring_tasks, :key, unique: true
    add_index :solid_queue_recurring_tasks, :static
  end
end
