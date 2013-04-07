class CreateJoinRequests < ActiveRecord::Migration
  def change
    create_table :join_requests do |t|
      t.integer :sender_id
      t.text :sender_type
      t.integer :receiver_id
      t.string :receive_type
      t.text :message

      t.timestamps
    end
  end
end
