class CreateHappeningSchedules < ActiveRecord::Migration
  def change
    create_table :happening_schedules do |t|
      t.integer :user_id
      t.integer :happening_case_id
      t.datetime :date_and_time
      t.boolean :email_delivered, default: false

      t.timestamps
    end
  end
end
