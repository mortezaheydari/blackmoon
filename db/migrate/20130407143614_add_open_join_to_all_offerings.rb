class AddOpenJoinToAllOfferings < ActiveRecord::Migration
  def change
	add_column :events , :open_join, :boolean, :default => 0, :null => false
	add_column :games , :open_join, :boolean, :default => 0, :null => false
	add_column :teams , :open_join, :boolean, :default => 0, :null => false
  end
end
