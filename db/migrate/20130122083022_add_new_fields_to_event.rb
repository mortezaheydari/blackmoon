class AddNewFieldsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :duration_type, :string
    add_column :events, :time_from, :time
    add_column :events, :time_to, :time
    add_column :events, :fee, :float
    add_column :events, :fee_type, :string
    add_column :events, :sport, :string
    add_column :events, :number_of_attendings, :integer
    add_column :events, :team_participation, :boolean
  end
end
