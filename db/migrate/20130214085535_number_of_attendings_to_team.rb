class NumberOfAttendingsToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :number_of_attendings, :integer  	
  end
end
