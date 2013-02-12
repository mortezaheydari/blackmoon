class CreateActCreations < ActiveRecord::Migration
  def change
    create_table :act_creations do |t|
      t.integer :creator_id
      t.integer :offering_id
      t.string :offering_type

      t.timestamps
    end
  end
end
