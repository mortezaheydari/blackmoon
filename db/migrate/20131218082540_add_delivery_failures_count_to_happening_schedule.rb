class AddDeliveryFailuresCountToHappeningSchedule < ActiveRecord::Migration
  def change
    add_column :happening_schedules, :delivery_failure_count, :integer, default: 0 
  end
end
