class AddUserIdToProfiles < ActiveRecord::Migration
  def change
  	change_table :profiles do |t|
			t.integer :user_id
  	end
  	add_index :profiles, :user_id
  end
end
