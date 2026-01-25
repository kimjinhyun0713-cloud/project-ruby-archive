class RecreateSolidQueueProcesses < ActiveRecord::Migration[7.1]
  def change
    connection.execute("DROP INDEX IF EXISTS index_solid_queue_processes_on_last_heartbeat_at")
    connection.execute("DROP INDEX IF EXISTS index_solid_queue_processes_on_supervisor_id")
    drop_table :solid_queue_processes, if_exists: true
    create_table :solid_queue_processes do |t|
      t.string :kind, null: false
      t.json :metadata
      t.integer :supervisor_id
      t.integer :pid, null: false
      t.string :hostname
      t.string :name, null: false
      t.datetime :last_heartbeat_at, null: false, index: true
      t.datetime :created_at, null: false
      t.index [ :last_heartbeat_at ], name: "index_solid_queue_processes_on_last_heartbeat_at"
      t.index [ :supervisor_id ], name: "index_solid_queue_processes_on_supervisor_id"
    end
  end
end