class AddAccountIdToUsers < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.integer :account_id
  	end
  	add_index :users, :account_id
  end
end
