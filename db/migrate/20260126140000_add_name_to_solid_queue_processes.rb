class AddNameToSolidQueueProcesses < ActiveRecord::Migration[7.1]
  def change
    add_column :solid_queue_processes, :name, :string, null: false
  end
end
