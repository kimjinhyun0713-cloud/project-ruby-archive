class AddPidAndHostnameToSolidQueueProcesses < ActiveRecord::Migration[7.1]
  def change
    # まだ足りていない pid と hostname を追加
    add_column :solid_queue_processes, :pid, :integer, null: false

    # hostnameはある場合とない場合があるので念のためチェック付きで
    unless column_exists?(:solid_queue_processes, :hostname)
      add_column :solid_queue_processes, :hostname, :string
    end
  end
end
