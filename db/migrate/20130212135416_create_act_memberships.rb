class CreateActMemberships < ActiveRecord::Migration
  def change
    create_table :act_memberships do |t|
      t.integer :member_id
      t.integer :act_id
      t.string :act_type

      t.timestamps
    end
  end
end
