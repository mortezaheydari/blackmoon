class RemoveDateAndTimeFromEvent < ActiveRecord::Migration
  def up
    remove_column :events, :date_and_time
    remove_column :events, :time_from
    remove_column :events, :time_to
    remove_column :events, :duration_type
  end

  def down
    add_column :events, :duration_type, :string
    add_column :events, :time_to, :time
    add_column :events, :time_from, :time
    add_column :events, :date_and_time, :datetime
  end
end
