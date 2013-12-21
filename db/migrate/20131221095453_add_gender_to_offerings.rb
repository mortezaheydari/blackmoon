class AddGenderToOfferings < ActiveRecord::Migration
  def change
    add_column :games, :gender, :string, default: "none"
    add_column :events, :gender, :string, default: "none"
    add_column :venues, :gender, :string, default: "none"
    add_column :personal_trainers, :gender, :string, default: "none"
    add_column :group_trainings, :gender, :string, default: "none"
    add_column :teams, :gender, :string, default: "none"                    
  end
end
