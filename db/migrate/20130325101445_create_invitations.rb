class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :inviter_type
      t.integer :invited_id
      t.string :invited_type
      t.integer :subject_id
      t.string :subject_type
      t.string :state
      t.text :message
      t.datetime :submission_datetime
      t.datetime :response_datetime

      t.timestamps
    end
  end
end
