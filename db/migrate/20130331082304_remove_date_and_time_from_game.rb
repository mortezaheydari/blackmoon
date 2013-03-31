class RemoveDateAndTimeFromGame < ActiveRecord::Migration
  def up
    remove_column :games, :date_and_time
    remove_column :games, :time_from
    remove_column :games, :time_to
    remove_column :games, :duration_type
  end

  def down
    add_column :games, :duration_type, :string
    add_column :games, :time_to, :time
    add_column :games, :time_from, :time
    add_column :games, :date_and_time, :datetime
  end
end
